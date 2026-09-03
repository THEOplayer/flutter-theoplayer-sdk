---
name: testing-web-integration
description: How to run THEOplayer Flutter SDK web integration tests and the example app on Chrome locally (macOS)
---

# Running web integration tests locally (macOS)

## One-time setup
- `export PATH="$HOME/development/flutter/bin:$HOME/.pub-cache/bin:$PATH"` (Flutter + melos)
- Install matching Chrome for Testing + chromedriver (no system Chrome needed):
  `npx --yes @puppeteer/browsers install chrome@stable` → `/Users/devin/chrome/<ver>/chrome-mac-arm64/Google Chrome for Testing.app/...`
  `npx --yes @puppeteer/browsers install chromedriver@stable` → `/Users/devin/chromedriver/<ver>/chromedriver-mac-arm64/chromedriver`
  Versions must match major.

## Run the web integration suite
1. `chromedriver --port=4444 &`
2. From `flutter_theoplayer_sdk/flutter_theoplayer_sdk/example`:
   `flutter drive --driver=webdriver_integration_test/webdriver.dart --target=integration_test_single_entrypoint/entrypoint.dart -d web-server --profile --driver-port=4444 --web-browser-flag="--disable-web-security --autoplay-policy=no-user-gesture-required" --chrome-binary "<Chrome for Testing binary>"`
   (mirrors `.github/workflows/pr_web.yml`; add `--wasm` for the wasm pass)
3. Success = "All tests passed." Gotcha: on failure, "Failure Details" is often EMPTY —
   to debug, run the example app with `flutter run -d chrome` (set CHROME_EXECUTABLE to the
   Chrome for Testing binary) where compile errors and print() output stream to the terminal.
4. To iterate faster, temporarily comment out other suites in
   `integration_test_single_entrypoint/entrypoint.dart` (revert afterwards).

## Example app on Chrome
- `flutter run -d chrome --web-browser-flag="--autoplay-policy=no-user-gesture-required"` from example/.
- theoplayer.com streams (incl. localhost) play without a license; the "License configuration
  needed!" dialog is informational — click OK.
- Dart `print()` output appears in the flutter run terminal, not the browser console.
- GUI automation gotcha: `cliclick` clicks can land ~15-20px above screenshot coordinates on
  this box; verify with `cliclick m:x,y` + `screencapture -xC` (cursor visible) before clicking.

## Daterange specifics
- Web daterange text tracks arrive with mode `disabled`; ENTERCUE/EXITCUE only fire for
  non-disabled tracks (fixed in TextTrackImplWeb by forcing mode hidden). If enter/exit events
  stop firing on web again, check the track mode first.
