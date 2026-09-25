#!/bin/bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <simulator-udid>" >&2
  exit 64
fi

SIMULATOR_UDID="$1"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-2}"
VM_SERVICE_TIMEOUT_SECONDS="${VM_SERVICE_TIMEOUT_SECONDS:-90}"
ATTEMPT_TIMEOUT_SECONDS="${ATTEMPT_TIMEOUT_SECONDS:-1080}"
TOTAL_TIMEOUT_SECONDS="${TOTAL_TIMEOUT_SECONDS:-1320}"
POLL_INTERVAL_SECONDS="${POLL_INTERVAL_SECONDS:-2}"
TERM_GRACE_SECONDS="${TERM_GRACE_SECONDS:-10}"
LOG_DIR="${RUNNER_TEMP:-${TMPDIR:-/tmp}}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_DIR="$SCRIPT_DIR/../flutter_theoplayer_sdk/flutter_theoplayer_sdk/example"

test_pid=""
watchdog_pid=""

terminate_process() {
  local pid="$1"
  kill -TERM "$pid" 2>/dev/null || true
  sleep "$TERM_GRACE_SECONDS"
  kill -KILL "$pid" 2>/dev/null || true
}

cleanup() {
  if [ -n "$watchdog_pid" ]; then
    kill "$watchdog_pid" 2>/dev/null || true
  fi
  if [ -n "$test_pid" ]; then
    terminate_process "$test_pid"
  fi
}

handle_signal() {
  cleanup
  exit 143
}

trap cleanup EXIT
trap handle_signal INT TERM

cd "$EXAMPLE_DIR"

started_at="$(date +%s)"
total_timeout_marker="$LOG_DIR/integration-test-watchdog"
rm -f "$total_timeout_marker"

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  log="$LOG_DIR/flutter-test-attempt-$attempt.log"
  vm_service_marker="$LOG_DIR/vm-service-watchdog-$attempt"
  attempt_timeout_marker="$LOG_DIR/attempt-watchdog-$attempt"
  rm -f "$log" "$vm_service_marker" "$attempt_timeout_marker"

  flutter test integration_test_single_entrypoint/entrypoint.dart \
    -d "$SIMULATOR_UDID" \
    --verbose > "$log" 2>&1 &
  test_pid=$!

  (
    attempt_elapsed=0
    vm_service_elapsed=0
    while kill -0 "$test_pid" 2>/dev/null; do
      total_elapsed=$(( $(date +%s) - started_at ))
      if [ "$total_elapsed" -ge "$TOTAL_TIMEOUT_SECONDS" ]; then
        touch "$total_timeout_marker"
        echo "::error title=Flutter integration test watchdog::integration tests exceeded ${TOTAL_TIMEOUT_SECONDS}s"
        terminate_process "$test_pid"
        exit 0
      fi

      if grep -Fq 'Waiting for VM Service port to be available...' "$log" && ! grep -Fq 'VM Service URL on device:' "$log"; then
        vm_service_elapsed=$((vm_service_elapsed + POLL_INTERVAL_SECONDS))
        if [ "$vm_service_elapsed" -ge "$VM_SERVICE_TIMEOUT_SECONDS" ]; then
          touch "$vm_service_marker"
          echo "::warning title=Flutter VM Service watchdog::attempt $attempt did not discover the VM Service within ${VM_SERVICE_TIMEOUT_SECONDS}s"
          terminate_process "$test_pid"
          exit 0
        fi
      fi

      attempt_elapsed=$((attempt_elapsed + POLL_INTERVAL_SECONDS))
      if [ "$attempt_elapsed" -ge "$ATTEMPT_TIMEOUT_SECONDS" ]; then
        touch "$attempt_timeout_marker"
        echo "::error title=Flutter integration test watchdog::attempt $attempt exceeded ${ATTEMPT_TIMEOUT_SECONDS}s"
        terminate_process "$test_pid"
        exit 0
      fi

      sleep "$POLL_INTERVAL_SECONDS"
    done
  ) &
  watchdog_pid=$!

  set +e
  wait "$test_pid"
  status=$?
  set -e
  test_pid=""
  kill "$watchdog_pid" 2>/dev/null || true
  wait "$watchdog_pid" 2>/dev/null || true
  watchdog_pid=""

  if [ "$status" -eq 0 ] && [ ! -f "$vm_service_marker" ] && [ ! -f "$attempt_timeout_marker" ] && [ ! -f "$total_timeout_marker" ]; then
    tail -n 50 "$log"
    exit 0
  fi

  tail -n 300 "$log"

  if [ -f "$vm_service_marker" ] && [ "$attempt" -lt "$MAX_ATTEMPTS" ]; then
    echo "::warning title=Retrying iOS integration tests::resetting the simulator after a stalled VM Service connection"
    xcrun simctl shutdown "$SIMULATOR_UDID" || true
    xcrun simctl bootstatus "$SIMULATOR_UDID" -b
    attempt=$((attempt + 1))
    continue
  fi

  if [ "$status" -eq 0 ]; then
    status=1
  fi
  exit "$status"
done
