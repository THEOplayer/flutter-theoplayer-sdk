# Memory Leak Performance Test with Perfetto

## Context
No memory/leak profiling tests exist in the THEOplayer Flutter SDK. This test repeatedly creates a player, loads a source, plays briefly, destroys the player, and uses Perfetto to detect native + Dart memory leaks.

## Prerequisites / Dependencies

### Host machine (macOS / Linux)
```bash
# 1. Android SDK with adb
#    Ensure adb is in PATH and a device/emulator is connected
adb devices

# 2. Python 3 with perfetto package
python3 -m pip install --break-system-packages perfetto

# 3. Download the Perfetto trace_processor binary (avoids timeout during analysis)
#    This is a Python wrapper script that auto-downloads the platform-specific binary
curl -LO https://get.perfetto.dev/trace_processor && chmod +x trace_processor
./trace_processor --version   # triggers binary download to ~/.local/share/perfetto/prebuilts/

# 4. Flutter SDK (with Android toolchain configured)
flutter doctor
```

### CI setup (GitHub Actions example)
```yaml
- name: Install Perfetto dependencies
  run: |
    python3 -m pip install --break-system-packages perfetto
    curl -LO https://get.perfetto.dev/trace_processor
    chmod +x trace_processor
    ./trace_processor --version
    rm trace_processor  # wrapper no longer needed, binary is cached

- name: Run memory leak test
  run: |
    cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example
    MEMORY_TEST_ITERATIONS=5 bash ../../../scripts/run_memory_test.sh

- name: Upload memory trace
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: memory-trace
    path: flutter_theoplayer_sdk/flutter_theoplayer_sdk/example/test_results/
```

## Files

### 1. `example/integration_test/memory_leak_test.dart`
Flutter integration test that cycles player create/load/play/destroy N times.

- Reuses existing `TestApp` pattern from `integration_test_app/test_app.dart`
- Each cycle: pump widget -> wait for `playerReady` -> set source -> wait for playing state -> dispose widget (via pumping `SizedBox.shrink()`) -> `pumpAndSettle`
- Default 10 iterations, configurable via `--dart-define=MEMORY_TEST_ITERATIONS=N`
- Uses the `cdn.theoplayer.com` Big Buck Bunny HLS stream (allowed by test license)
- Tests both `HYBRID_COMPOSITION` and `SURFACE_TEXTURE` modes as separate `testWidgets`
- Adds deliberate delays between cycles to let GC settle (~2s)
- Prints `MEMORY_TEST:` markers to stdout with timestamps for trace correlation

### 2. `scripts/perfetto_memory_config.textproto`
Perfetto trace config for Android memory profiling:
- `linux.process_stats` data source: polls RSS/PSS/swap counters at 1Hz
- `linux.ftrace` for kernel memory events (`kmem/rss_stat`, `mm_event/mm_event_record`, `oom/oom_score_adj_update`)
- Duration: 120s (enough for 10 cycles at ~7s each)
- Buffer size: 64MB ring buffer

**Note:** The `QUIRKS_CLEAR_STATS_ON_CLONE` quirk was removed because it is not supported on all Android versions and causes a config parse error on older devices.

### 3. `scripts/run_memory_test.sh`
Orchestration script with five phases:
```
Phase 1: Validate adb connection, find device, print config
Phase 2: Push perfetto config, start `perfetto --background` on device
Phase 3: Run `flutter test integration_test/memory_leak_test.dart` with --dart-define
Phase 4: Stop perfetto (kill PID), pull trace file to local `test_results/`
Phase 5: Run analyze_memory_trace.py, print summary, exit with pass/fail code
```

Environment variables:
| Variable | Default | Description |
|---|---|---|
| `MEMORY_TEST_ITERATIONS` | `10` | Number of create/destroy cycles |
| `MEMORY_LEAK_THRESHOLD_MB` | `50` | Max allowed memory growth (MB) before FAIL |
| `OUTPUT_DIR` | `example/test_results/` | Directory for trace and report files |

Implementation details:
- Trace is written to `/data/misc/perfetto-traces/` on device (the standard Perfetto output directory, writable by the `perfetto` daemon). **Do not use `/data/local/tmp/`** -- the perfetto process runs as a different user and cannot write there.
- Cleanup trap removes device-side trace and config files on exit
- Auto-detects `PERFETTO_TP_BIN` at `~/.local/share/perfetto/prebuilts/trace_processor_shell` to avoid download timeouts during analysis
- Test failures (e.g. source errors) do not abort the script -- trace collection and analysis still run

### 4. `scripts/analyze_memory_trace.py`
Python 3 script using `perfetto.trace_processor` to analyze the collected trace:
- Loads trace into TraceProcessor (uses `PERFETTO_TP_BIN` env var if set to avoid re-downloading the binary)
- Finds the target process by package name in the `process` table
- Queries `counter` + `process_counter_track` tables for memory counters
- Prefers `mem.rss.anon` > `mem.rss` > first available counter
- Computes: baseline (sample at ~10% mark), final, peak, delta
- Leak detection: if `final - baseline > threshold_mb` -> **FAIL**
- Outputs JSON report with subsampled timeline (~100 points) + verdict
- Prints human-readable summary to stdout
- Exit code: 0 = PASS/SKIP, 1 = FAIL (leak detected)

Available counters from a typical trace: `mem.rss`, `mem.rss.anon`, `mem.rss.file`, `mem.rss.shmem`, `mem.rss.watermark`, `mem.virt`, `mem.swap`, `mem.locked`

## Running

### Quick run (3 iterations, faster feedback)
```bash
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example
MEMORY_TEST_ITERATIONS=3 bash ../../../scripts/run_memory_test.sh
```

### Full run (10 iterations, ~2 minutes of tracing)
```bash
cd flutter_theoplayer_sdk/flutter_theoplayer_sdk/example
bash ../../../scripts/run_memory_test.sh
```

### Analysis only (on an existing trace)
```bash
PERFETTO_TP_BIN="$HOME/.local/share/perfetto/prebuilts/trace_processor_shell" \
python3 scripts/analyze_memory_trace.py \
  --trace test_results/memory_trace.perfetto-trace \
  --package com.theoplayer.theoplayer_example \
  --threshold 50 \
  --output test_results/memory_report.json
```

### View trace in Perfetto UI
Open https://ui.perfetto.dev and load the `.perfetto-trace` file from `test_results/`.

## Example output
```
==================================================
Memory Analysis Summary (mem.rss.anon)
==================================================
  Baseline (after settle): 72.5 MB
  Final:                   20.5 MB
  Peak:                    181.7 MB
  Delta (final-baseline):  -52.0 MB
  Threshold:               50.0 MB

  Verdict: PASS

Report saved to: test_results/memory_report.json
```
### What the Memory Leak Test Does 
The test simulates real-world usage where a player is repeatedly created and destroyed — like navigating in and out of a video screen.

Each cycle (repeated 10 times by default):
1. Creates a TestApp with a THEOplayer instance
2. Waits for the player to initialize
3. Sets a THEOlive source and plays for ~5 seconds
4. Destroys the player by replacing the widget with an
empty SizedBox.shrink()
1. Waits ~2 seconds for garbage collection to settle

This runs as two separate tests — one for HYBRID_COMPOSITION and one for SURFACE_TEXTURE (Android rendering modes).

Meanwhile, Perfetto traces memory (RSS) on the device at 1Hz. After the test, the Python analysis script checks whether memory grew beyond a threshold.

What the Results Mean

From the actual run:

Baseline (after settle): 72.5 MB    ← memory after first cycle settled
Final:                   20.5 MB    ← memory after all cycles completed
Peak:                    181.7 MB   ← highest memory during playback
Delta (final-baseline):  -52.0 MB   ← memory change over time
Threshold:               50.0 MB
Verdict: PASS

- Baseline 72.5 MB: The app's memory footprint after the first create/play/destroy cycle settled.
- Peak 181.7 MB: During active playback, the player allocates video buffers, decoders, etc. This is expected.
- Final 20.5 MB: After all cycles completed and the player was destroyed. It dropped below baseline because the app was idle with no player.
- Delta -52.0 MB: Memory went down, meaning no leak. The native player resources, video buffers, and Dart objects were properly released on each destroy.
- PASS: The delta is below the 50 MB threshold (it's actually negative), so no leak was detected.

If there were a leak, you'd see the final memory climb with each iteration (e.g., baseline 72 MB → final 180 MB → delta +108 MB → FAIL). That would indicate the native SDK or Flutter binding isn't releasing resources on dispose.

## Perfetto UI-
Find the right process (`com.theoplayer.theoplayer_example` PID 27050). Here's what to look for:

## Key Counters

**`mem.rss.anon`** (200M scale) — This is the most important one. It shows anonymous memory (heap allocations, native buffers, Dart VM). This is what our analysis script uses.
- Look for a **sawtooth pattern**: spikes up when player is created/playing, drops when destroyed
- If each successive peak is higher than the last → potential leak
- If the valleys (after destroy) keep rising → definite leak

**`mem.rss`** (400M scale) — Total resident memory (anon + file-backed + shared). Useful as an overall view but noisier because file-backed pages (shared libs, mmap'd files) can fluctuate.

**`mem.rss.file`** (200M scale) — Memory-mapped files (shared libraries, APK assets). Should be roughly flat after initial load. If it keeps growing, the player may be loading and not releasing native libraries.

## What to Look For in Your Trace

From your screenshot, the counters appear mostly flat/stable across the test duration, which is consistent with the **PASS** verdict. Zoom in on `mem.rss.anon` to check:

1. **Zoom in** (scroll wheel or drag-select the time range) to see individual cycles
2. You should see ~3 bumps (your 3-iteration run) in `mem.rss.anon`
3. Check that the **valley after each bump returns to roughly the same level** — that means memory is being released properly
4. If the valleys trend upward, that's the leak amount per cycle

## Counters You Can Ignore
- **`mem.virt`** (25G) — Virtual address space, not actual physical memory. Always large on Android, not meaningful for leak detection.
- **`mem.locked`** — Typically zero, not relevant
- **`oom_score_adj`** — OOM killer priority, not memory usage
- **`mem.swap`** / **`mem.rss.shmem`** — Usually small and stable
- 
## Key Files Referenced
- `example/integration_test_app/test_app.dart` -- TestApp widget pattern
- `example/integration_test/playback_test.dart` -- source loading / play patterns
- `flutter_theoplayer_sdk/lib/src/theoplayer_internal.dart` -- player dispose chain
- `.github/workflows/pr_android.yml` -- CI integration point (future step)

## Known issues / Gotchas
- **Perfetto `QUIRKS_CLEAR_STATS_ON_CLONE`**: Not supported on all Android versions. Removed from config.
- **Trace output path**: Must use `/data/misc/perfetto-traces/`, not `/data/local/tmp/` (permissions).
- **`perfetto` Python package**: The `TraceProcessor` auto-downloads a ~50MB `trace_processor_shell` binary on first use. On slow networks or CI, this can time out. Pre-download with `curl -LO https://get.perfetto.dev/trace_processor && ./trace_processor --version` and set `PERFETTO_TP_BIN=$HOME/.local/share/perfetto/prebuilts/trace_processor_shell`.
- **Source errors**: The test may log `THEOplayerException: Source error` if the license doesn't allow the stream. The test still completes (it checks `currentTime >= 0`, not `> 0`). Set `TEST_LICENSE` via `--dart-define` if needed.
- **NDK version warning**: The build may warn about NDK version mismatch (`integration_test` plugin wants 28.x). This is cosmetic and doesn't affect the test.
