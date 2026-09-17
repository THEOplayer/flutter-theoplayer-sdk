#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXAMPLE_DIR="$REPO_ROOT/flutter_theoplayer_sdk/flutter_theoplayer_sdk/example"

ITERATIONS="${MEMORY_TEST_ITERATIONS:-10}"
THRESHOLD_MB="${MEMORY_LEAK_THRESHOLD_MB:-50}"
OUTPUT_DIR="${OUTPUT_DIR:-$EXAMPLE_DIR/test_results}"
APP_PACKAGE="com.theoplayer.theoplayer_example"
PERFETTO_CONFIG="$SCRIPT_DIR/perfetto_memory_config.textproto"
TRACE_FILE="$OUTPUT_DIR/memory_trace.perfetto-trace"
REPORT_FILE="$OUTPUT_DIR/memory_report.json"

DEVICE_TRACE_PATH="/data/misc/perfetto-traces/memory_test.perfetto-trace"
PERFETTO_PID=""

cleanup() {
    echo "Cleaning up..."
    if [ -n "$PERFETTO_PID" ]; then
        adb shell "kill $PERFETTO_PID 2>/dev/null || true"
    fi
    adb shell "rm -f $DEVICE_TRACE_PATH 2>/dev/null || true"
    adb shell "rm -f /data/local/tmp/perfetto_memory_config.textproto 2>/dev/null || true"
}
trap cleanup EXIT

# Phase 1: Validate
echo "=== Phase 1: Validating environment ==="
if ! command -v adb &>/dev/null; then
    echo "ERROR: adb not found in PATH"
    exit 1
fi

DEVICE=$(adb devices | grep -w "device" | head -1 | awk '{print $1}')
if [ -z "$DEVICE" ]; then
    echo "ERROR: No Android device connected"
    exit 1
fi
echo "Device: $DEVICE"
echo "App package: $APP_PACKAGE"
echo "Iterations: $ITERATIONS"
echo "Threshold: ${THRESHOLD_MB}MB"

mkdir -p "$OUTPUT_DIR"

# Phase 2: Start Perfetto trace
echo ""
echo "=== Phase 2: Starting Perfetto trace ==="
adb push "$PERFETTO_CONFIG" /data/local/tmp/perfetto_memory_config.textproto

# Start perfetto in background on device, writing to /data/local/tmp/ (accessible without root)
adb shell "cat /data/local/tmp/perfetto_memory_config.textproto | perfetto --txt -c - -o $DEVICE_TRACE_PATH --background 2>&1"
sleep 3

# Get the perfetto PID on device
PERFETTO_PID=$(adb shell "pidof perfetto" 2>/dev/null | tr -d '[:space:]')
if [ -z "$PERFETTO_PID" ]; then
    echo "WARNING: Could not find perfetto PID, trace may not be running"
else
    echo "Perfetto tracing started (PID: $PERFETTO_PID)"
fi

# Phase 3: Run Flutter integration test
echo ""
echo "=== Phase 3: Running memory leak test ==="
cd "$EXAMPLE_DIR"
flutter test integration_test/memory_leak_test.dart \
    --dart-define=MEMORY_TEST_ITERATIONS="$ITERATIONS" \
    || true  # Don't fail the whole script if test has assertion issues

# Phase 4: Stop Perfetto and pull trace
echo ""
echo "=== Phase 4: Collecting trace ==="
if [ -n "$PERFETTO_PID" ]; then
    adb shell "kill $PERFETTO_PID 2>/dev/null || true"
    sleep 2
fi

# Verify the trace file exists on device before pulling
if adb shell "test -f $DEVICE_TRACE_PATH && echo exists" 2>/dev/null | grep -q exists; then
    adb pull "$DEVICE_TRACE_PATH" "$TRACE_FILE"
else
    echo "WARNING: Trace file not found on device at $DEVICE_TRACE_PATH"
    echo "Perfetto may not have started correctly. Check 'adb shell perfetto --help' for supported options."
fi

if [ -f "$TRACE_FILE" ]; then
    echo "Trace saved to: $TRACE_FILE"
    echo "View in Perfetto UI: https://ui.perfetto.dev"
else
    echo "WARNING: No trace file collected"
fi

# Phase 5: Analyze
echo ""
echo "=== Phase 5: Analyzing memory trace ==="
if [ -f "$TRACE_FILE" ]; then
    # Set trace_processor binary path if available (avoids re-download)
    TP_BIN="$HOME/.local/share/perfetto/prebuilts/trace_processor_shell"
    if [ -x "$TP_BIN" ]; then
        export PERFETTO_TP_BIN="$TP_BIN"
    fi
    python3 "$SCRIPT_DIR/analyze_memory_trace.py" \
        --trace "$TRACE_FILE" \
        --package "$APP_PACKAGE" \
        --threshold "$THRESHOLD_MB" \
        --output "$REPORT_FILE"
    EXIT_CODE=$?
else
    echo "Skipping analysis: no trace file"
    EXIT_CODE=0
fi

echo ""
echo "=== Done ==="
echo "Results in: $OUTPUT_DIR"
exit $EXIT_CODE
