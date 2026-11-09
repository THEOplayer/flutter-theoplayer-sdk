#!/usr/bin/env bash
set -euo pipefail

STALL_SECONDS=30
MAX_ATTEMPTS=5
log_dir="${RUNNER_TEMP:-$PWD}/ios-integration-logs"
mkdir -p "$log_dir"
flutter_pid=

# Recursively freezes (SIGSTOP) a process and its descendants, collecting their PIDs
# in the caller's tree_pids array so cleanup() can kill the whole tree at once.
stop_tree() {
  local pid=$1 child
  kill -STOP "$pid" 2>/dev/null || return 0
  tree_pids+=("$pid")
  for child in $(pgrep -P "$pid" || true); do
    stop_tree "$child"
  done
}

cleanup() {
  local tree_pids=()
  if [[ -n $flutter_pid ]]; then
    # Freeze parents before discovering children so they cannot spawn more.
    stop_tree "$flutter_pid"
    if (( ${#tree_pids[@]} > 0 )); then
      kill -TERM "${tree_pids[@]}" 2>/dev/null || true
      kill -CONT "${tree_pids[@]}" 2>/dev/null || true
      sleep 1
      kill -KILL "${tree_pids[@]}" 2>/dev/null || true
    fi
    wait "$flutter_pid" 2>/dev/null || true
    flutter_pid=
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

diagnostics() {
  echo '::group::VM Service stall diagnostics (flutter/flutter#181771)'
  xcrun simctl list devices booted || true
  # Keep elapsed time and full commands in the diagnostic snapshot.
  # shellcheck disable=SC2009
  ps -axo pid,etime,command | grep -E 'simctl|log stream|Runner' | grep -v '[g]rep' || true
  echo '::endgroup::'
}

had_stall=false
for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
  echo "Starting iOS integration test attempt $attempt/$MAX_ATTEMPTS"
  log_file="$log_dir/attempt-$attempt.log"
  : > "$log_file"
  flutter test -v integration_test_single_entrypoint/entrypoint.dart > >(tee "$log_file") 2>&1 &
  flutter_pid=$!
  waiting_since=-1
  stalled=false
  while kill -0 "$flutter_pid" 2>/dev/null; do
    if grep -q 'VM Service URL on device' "$log_file"; then
      waiting_since=-1
      break
    fi
    if (( waiting_since < 0 )) && grep -q 'Waiting for VM Service port to be available' "$log_file"; then
      waiting_since=$SECONDS
    fi
    if (( waiting_since >= 0 && SECONDS-waiting_since >= STALL_SECONDS )); then
      stalled=true
      had_stall=true
      diagnostics
      cleanup
      break
    fi
    sleep 1
  done
  if [[ $stalled == true ]]; then
    if (( attempt == MAX_ATTEMPTS )); then
      echo '::error::iOS integration tests stalled waiting for the VM Service; see flutter/flutter#181771.'
      exit 1
    fi
    continue
  fi
  status=0
  wait "$flutter_pid" || status=$?
  flutter_pid=
  if (( status == 0 )) && [[ $had_stall == true ]]; then
    echo '::warning::iOS integration tests passed on retry after a VM Service stall (flutter/flutter#181771).'
  fi
  exit "$status"
done
