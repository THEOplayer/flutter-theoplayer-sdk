import '../integration_test/plugin_integration_test.dart' as plugin_tests;
import '../integration_test/player_creation_test.dart' as playercreation_tests;
import '../integration_test/playback_test.dart' as playback_tests;

// entry point for web integration tests to run them with `flutter drive`
void main() {
  plugin_tests.main();
  playercreation_tests.main();
  playback_tests.main();
}