import 'package:integration_test/integration_test.dart';

// Import all test files
import 'auth_flow_test.dart' as auth_tests;
import 'profile_flow_test.dart' as profile_tests;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Run all integration tests
  auth_tests.main();
  profile_tests.main();
}
