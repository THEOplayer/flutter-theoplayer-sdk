#!/usr/bin/env bash
set -euo pipefail

STALL_SECONDS=${STALL_SECONDS:-30}
MAX_ATTEMPTS=${MAX_ATTEMPTS:-2}
for value in "$STALL_SECONDS" "$MAX_ATTEMPTS"; do
  if [[ ! $value =~ ^[1-9][0-9]*$ ]]; then
    echo 'STALL_SECONDS and MAX_ATTEMPTS must be positive integers' >&2
    exit 2
  fi
done
log_dir="${RUNNER_TEMP:-$PWD}/ios-integration-logs"
mkdir -p "$log_dir"
flutter_pid=
logger_pid=
fifo=

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
  if [[ -n $logger_pid ]]; then
    wait "$logger_pid" 2>/dev/null || true
    logger_pid=
  fi
  [[ -z $fifo ]] || rm -f "$fifo"
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
  xcrun simctl listapps booted | grep -A3 theoplayerExample || echo 'example app not installed on the simulator (or listapps failed)'
  xcrun simctl spawn booted launchctl list | grep -i runner || true
  awk '
    /simctl launch/ && !launch { launch=NR; print "First simctl launch: " NR ":" $0 }
    /log stream/ && !stream { stream=NR; print "First log stream: " NR ":" $0 }
    END {
      if (!launch) print "No simctl launch line found"
      if (!stream) print "No log stream line found"
      if (launch && stream) print (launch < stream ? "simctl launch came first (#181771 signature)" : "log stream came first")
    }
  ' "$log_file" || true
  echo '::endgroup::'
}

had_stall=false
for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
  echo "Starting iOS integration test attempt $attempt/$MAX_ATTEMPTS"
  log_file="$log_dir/attempt-$attempt.log"
  : > "$log_file"
  fifo="$log_dir/attempt-$attempt.fifo"
  mkfifo "$fifo"
  started=$SECONDS
  (
    while IFS= read -r line || [[ -n $line ]]; do
      printf -v stamped '[%s +%ss] %s' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$((SECONDS-started))" "$line"
      printf '%s\n' "$stamped"
      printf '%s\n' "$stamped" >> "$log_file"
    done < "$fifo"
  ) &
  logger_pid=$!
  flutter test -v integration_test_single_entrypoint/entrypoint.dart "$@" > "$fifo" 2>&1 &
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
  wait "$logger_pid" || true
  logger_pid=
  rm -f "$fifo"
  fifo=
  if (( status == 0 )) && [[ $had_stall == true ]]; then
    echo '::warning::iOS integration tests passed on retry after a VM Service stall (flutter/flutter#181771).'
  fi
  exit "$status"
done
