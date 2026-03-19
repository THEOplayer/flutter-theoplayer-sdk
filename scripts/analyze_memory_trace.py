#!/usr/bin/env python3
"""Analyze a Perfetto trace for memory leaks in the THEOplayer example app.

Requires: pip install perfetto
"""

import argparse
import json
import os
import sys

def main():
    parser = argparse.ArgumentParser(description="Analyze Perfetto memory trace for leaks")
    parser.add_argument("--trace", required=True, help="Path to .perfetto-trace file")
    parser.add_argument("--package", default="com.theoplayer.theoplayer_example", help="Target app package name")
    parser.add_argument("--threshold", type=float, default=50.0, help="Leak threshold in MB")
    parser.add_argument("--output", default="memory_report.json", help="Output JSON report path")
    args = parser.parse_args()

    try:
        from perfetto.trace_processor import TraceProcessor
    except ImportError:
        print("ERROR: perfetto package not installed. Run: pip install perfetto")
        sys.exit(1)

    print(f"Loading trace: {args.trace}")
    tp = TraceProcessor(trace=args.trace)

    # Find the target process
    proc_query = f"""
        SELECT upid, pid, name
        FROM process
        WHERE name LIKE '%{args.package}%'
        ORDER BY pid DESC
        LIMIT 1
    """
    proc_result = tp.query(proc_query)
    proc_rows = list(proc_result)

    if not proc_rows:
        print(f"WARNING: Process '{args.package}' not found in trace.")
        print("Available processes:")
        for row in tp.query("SELECT DISTINCT name FROM process WHERE name IS NOT NULL ORDER BY name"):
            print(f"  {row.name}")
        report = {"verdict": "SKIP", "reason": "Process not found in trace", "package": args.package}
        with open(args.output, "w") as f:
            json.dump(report, f, indent=2)
        print(f"\nReport saved to: {args.output}")
        return 0

    upid = proc_rows[0].upid
    pid = proc_rows[0].pid
    proc_name = proc_rows[0].name
    print(f"Found process: {proc_name} (PID={pid}, UPID={upid})")

    # Query RSS memory counters for this process
    mem_query = f"""
        SELECT
            c.ts,
            c.value,
            t.name as counter_name
        FROM counter c
        JOIN process_counter_track t ON c.track_id = t.id
        WHERE t.upid = {upid}
          AND (t.name LIKE '%rss%' OR t.name LIKE '%mem%')
        ORDER BY c.ts ASC
    """
    mem_rows = list(tp.query(mem_query))

    if not mem_rows:
        # Try alternative: look at process memory from process_stats
        alt_query = f"""
            SELECT
                c.ts,
                c.value,
                t.name as counter_name
            FROM counter c
            JOIN process_counter_track t ON c.track_id = t.id
            WHERE t.upid = {upid}
            ORDER BY c.ts ASC
        """
        mem_rows = list(alt_query_result) if (alt_query_result := list(tp.query(alt_query))) else []

    if not mem_rows:
        print("WARNING: No memory counters found for target process")
        report = {"verdict": "SKIP", "reason": "No memory counters in trace", "package": args.package, "pid": pid}
        with open(args.output, "w") as f:
            json.dump(report, f, indent=2)
        print(f"\nReport saved to: {args.output}")
        return 0

    # Group by counter name
    counters = {}
    for row in mem_rows:
        name = row.counter_name
        if name not in counters:
            counters[name] = []
        counters[name].append({"ts": row.ts, "value_bytes": row.value})

    print(f"\nMemory counters found: {list(counters.keys())}")

    # Pick the best RSS counter (prefer rss.anon, then rss, then first available)
    preferred = ["mem.rss.anon", "mem.rss", "rss_stat", "mem.virt"]
    chosen_counter = None
    for pref in preferred:
        for name in counters:
            if pref in name.lower():
                chosen_counter = name
                break
        if chosen_counter:
            break
    if not chosen_counter:
        chosen_counter = list(counters.keys())[0]

    timeline = counters[chosen_counter]
    print(f"Using counter: {chosen_counter} ({len(timeline)} samples)")

    # Compute stats
    values_mb = [s["value_bytes"] / (1024 * 1024) for s in timeline]

    # Use samples from ~10% mark as baseline (after first cycle settles)
    baseline_idx = max(1, len(values_mb) // 10)
    baseline_mb = values_mb[baseline_idx]
    final_mb = values_mb[-1]
    peak_mb = max(values_mb)
    delta_mb = final_mb - baseline_mb

    print(f"\n{'='*50}")
    print(f"Memory Analysis Summary ({chosen_counter})")
    print(f"{'='*50}")
    print(f"  Baseline (after settle): {baseline_mb:.1f} MB")
    print(f"  Final:                   {final_mb:.1f} MB")
    print(f"  Peak:                    {peak_mb:.1f} MB")
    print(f"  Delta (final-baseline):  {delta_mb:+.1f} MB")
    print(f"  Threshold:               {args.threshold:.1f} MB")

    leaked = delta_mb > args.threshold
    verdict = "FAIL" if leaked else "PASS"
    print(f"\n  Verdict: {verdict}")
    if leaked:
        print(f"  Memory grew by {delta_mb:.1f} MB, exceeding threshold of {args.threshold:.1f} MB")

    # Build report
    timeline_report = [
        {"ts_ns": s["ts"], "value_mb": round(s["value_bytes"] / (1024 * 1024), 2)}
        for s in timeline[::max(1, len(timeline) // 100)]  # Subsample to ~100 points
    ]

    report = {
        "verdict": verdict,
        "package": args.package,
        "pid": pid,
        "counter": chosen_counter,
        "samples": len(timeline),
        "baseline_mb": round(baseline_mb, 2),
        "final_mb": round(final_mb, 2),
        "peak_mb": round(peak_mb, 2),
        "delta_mb": round(delta_mb, 2),
        "threshold_mb": args.threshold,
        "leaked": leaked,
        "timeline": timeline_report,
    }

    with open(args.output, "w") as f:
        json.dump(report, f, indent=2)
    print(f"\nReport saved to: {args.output}")

    return 1 if leaked else 0


if __name__ == "__main__":
    sys.exit(main())
