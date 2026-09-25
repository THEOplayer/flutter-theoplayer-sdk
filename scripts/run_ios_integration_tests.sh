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
test_process_group=""
watchdog_pid=""

process_group_exists() {
  kill -0 -- "-$1" 2>/dev/null
}

terminate_process_group() {
  local process_group="$1"
  local elapsed=0
  kill -TERM -- "-$process_group" 2>/dev/null || true
  while process_group_exists "$process_group" && [ "$elapsed" -lt "$TERM_GRACE_SECONDS" ]; do
    sleep 1
    elapsed=$((elapsed + 1))
  done
  if process_group_exists "$process_group"; then
    kill -KILL -- "-$process_group" 2>/dev/null || true
    sleep 1
  fi
}

print_log_tail() {
  local line_count="$1"
  local log="$2"
  sed -E '/^[[:space:]]*export [A-Za-z_][A-Za-z0-9_]*=/d; /TEST_LICENSE/d' "$log" | tail -n "$line_count"
}

cleanup() {
  if [ -n "$test_process_group" ]; then
    terminate_process_group "$test_process_group"
  fi
  if [ -n "$watchdog_pid" ]; then
    kill "$watchdog_pid" 2>/dev/null || true
    wait "$watchdog_pid" 2>/dev/null || true
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

  set -m
  flutter test integration_test_single_entrypoint/entrypoint.dart \
    -d "$SIMULATOR_UDID" \
    --verbose > "$log" 2>&1 &
  test_pid=$!
  test_process_group="$test_pid"
  set +m

  (
    attempt_elapsed=0
    vm_service_elapsed=0
    while process_group_exists "$test_process_group"; do
      total_elapsed=$(( $(date +%s) - started_at ))
      if [ "$total_elapsed" -ge "$TOTAL_TIMEOUT_SECONDS" ]; then
        touch "$total_timeout_marker"
        echo "::error title=Flutter integration test watchdog::integration tests exceeded ${TOTAL_TIMEOUT_SECONDS}s"
        terminate_process_group "$test_process_group"
        exit 0
      fi

      if grep -Fq 'Waiting for VM Service port to be available...' "$log" && ! grep -Fq 'VM Service URL on device:' "$log"; then
        vm_service_elapsed=$((vm_service_elapsed + POLL_INTERVAL_SECONDS))
        if [ "$vm_service_elapsed" -ge "$VM_SERVICE_TIMEOUT_SECONDS" ]; then
          touch "$vm_service_marker"
          echo "::warning title=Flutter VM Service watchdog::attempt $attempt did not discover the VM Service within ${VM_SERVICE_TIMEOUT_SECONDS}s"
          terminate_process_group "$test_process_group"
          exit 0
        fi
      fi

      attempt_elapsed=$((attempt_elapsed + POLL_INTERVAL_SECONDS))
      if [ "$attempt_elapsed" -ge "$ATTEMPT_TIMEOUT_SECONDS" ]; then
        touch "$attempt_timeout_marker"
        echo "::error title=Flutter integration test watchdog::attempt $attempt exceeded ${ATTEMPT_TIMEOUT_SECONDS}s"
        terminate_process_group "$test_process_group"
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

  if [ -f "$vm_service_marker" ] || [ -f "$attempt_timeout_marker" ] || [ -f "$total_timeout_marker" ]; then
    wait "$watchdog_pid" 2>/dev/null || true
  else
    kill "$watchdog_pid" 2>/dev/null || true
    wait "$watchdog_pid" 2>/dev/null || true
    kill -TERM -- "-$test_process_group" 2>/dev/null || true
  fi

  test_pid=""
  test_process_group=""
  watchdog_pid=""

  if [ "$status" -eq 0 ] && [ ! -f "$vm_service_marker" ] && [ ! -f "$attempt_timeout_marker" ] && [ ! -f "$total_timeout_marker" ]; then
    print_log_tail 50 "$log"
    exit 0
  fi

  print_log_tail 300 "$log"

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
