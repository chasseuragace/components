import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import 'test_app.dart';
import 'helpers/test_helpers.dart';
import 'mocks/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Udaan Sarathi Authentication Flow Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late ProviderContainer container;
    late TokenStorage tokenStorage;

    setUp(() async {
      // Create clean shared preferences for each test
      sharedPreferences = await TestHelpers.createCleanSharedPreferences();
      
      // Create token storage
      tokenStorage = TokenStorage(SharedPrefsLocalStorage(sharedPreferences));
      
      // Create provider container with overrides
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ...MockProviders.createOverrides(tokenStorage),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await sharedPreferences.clear();
    });

    testWidgets('User Registration Flow - New User Registration with OTP Verification', (tester) async {
      final userData = TestHelpers.createMockUserData();
      
      // Launch the app
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Test user registration
      print('Testing user registration...');
      final otp = await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      // Wait for auth state to update
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify OTP was returned
      expect(otp, isNotEmpty);
      expect(otp, equals('123456')); // Mock OTP
      
      // Verify auth state
      final authState = container.read(authControllerProvider);
      expect(authState.responseState, ResponseStates.success);
      expect(authState.message, 'OTP sent successfully');
      expect(authState.loading, false);
      
      print('✓ User registration successful');
    });

    testWidgets('OTP Verification Flow - Verify OTP and Get Token', (tester) async {
      final userData = TestHelpers.createMockUserData();
      
      // Launch the app
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // First register user
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      await TestHelpers.waitForAuthState(tester, container);
      
      // Test OTP verification
      print('Testing OTP verification...');
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
      // Wait for auth state to update
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify token was returned and stored
      expect(token, isNotEmpty);
      expect(token, startsWith('mock_token_'));
      
      // Verify auth state
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, true);
      expect(authState.token, equals(token));
      expect(authState.responseState, ResponseStates.success);
      expect(authState.message, 'Verified');
      
      // Verify token is stored in SharedPreferences
      await TestHelpers.verifyTokenStored(sharedPreferences);
      
      // Verify candidate ID is stored
      await TestHelpers.verifyCandidateIdStored(sharedPreferences);
      
      print('✓ OTP verification successful');
      print('✓ Token stored in local storage');
      print('✓ Candidate ID stored in local storage');
    });

    testWidgets('Existing User Login Flow - Login Start and Verify', (tester) async {
      final userData = TestHelpers.createMockUserData();
      
      // Launch the app
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // First register user to simulate existing user
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      await TestHelpers.waitForAuthState(tester, container);
      
      // Clear auth state to simulate logout
      await authController.logout();
      await TestHelpers.waitForAuthState(tester, container);
      
      // Test login start
      print('Testing login start...');
      final loginOtp = await authController.loginStart(
        phone: userData['phone']!,
      );
      
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify OTP was returned
      expect(loginOtp, isNotEmpty);
      expect(loginOtp, equals('123456')); // Mock OTP
      
      // Verify auth state
      var authState = container.read(authControllerProvider);
      expect(authState.responseState, ResponseStates.success);
      expect(authState.message, 'OTP sent');
      
      // Test login verify
      print('Testing login verification...');
      final loginToken = await authController.loginVerify(
        phone: userData['phone']!,
        otp: loginOtp,
      );
      
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify token was returned and stored
      expect(loginToken, isNotEmpty);
      expect(loginToken, startsWith('mock_token_'));
      
      // Verify auth state
      authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, true);
      expect(authState.token, equals(loginToken));
      expect(authState.responseState, ResponseStates.success);
      expect(authState.message, 'Welcome back');
      
      // Verify token is stored in SharedPreferences
      await TestHelpers.verifyTokenStored(sharedPreferences);
      
      // Verify candidate ID is stored
      await TestHelpers.verifyCandidateIdStored(sharedPreferences);
      
      print('✓ Login flow successful');
      print('✓ User can login with existing credentials');
    });

    testWidgets('Session Persistence - Check Auth on Launch', (tester) async {
      final userData = TestHelpers.createMockUserData();
      
      // First, create a session
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Get auth controller and create session
      final authController = container.read(authControllerProvider.notifier);
      
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      await TestHelpers.waitForAuthState(tester, container);
      
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify session was created
      expect(token, isNotEmpty);
      
      // Dispose current container
      container.dispose();
      
      // Create new container to simulate app restart
      final newContainer = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ...MockProviders.createOverrides(tokenStorage),
        ],
      );
      
      // Launch app again
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: newContainer,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Test session restoration
      print('Testing session persistence...');
      final newAuthController = newContainer.read(authControllerProvider.notifier);
      await newAuthController.checkAuthOnLaunch();
      
      // Wait for auth state to update
      await TestHelpers.waitForAuthState(tester, newContainer);
      
      // Verify session was restored
      final authState = newContainer.read(authControllerProvider);
      expect(authState.isAuthenticated, true);
      expect(authState.token, isNotEmpty);
      expect(authState.responseState, ResponseStates.success);
      expect(authState.message, 'Session restored');
      
      print('✓ Session persistence working');
      print('✓ User remains logged in after app restart');
      
      newContainer.dispose();
    });

    testWidgets('Error Handling - Invalid OTP', (tester) async {
      final userData = TestHelpers.createMockUserData();
      
      // Launch the app
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            sharedPreferences: sharedPreferences,
            overrides: MockProviders.createOverrides(tokenStorage),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Register user first
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      await TestHelpers.waitForAuthState(tester, container);
      
      // Test with invalid OTP
      print('Testing error handling with invalid OTP...');
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: 'wrong_otp',
      );
      
      await TestHelpers.waitForAuthState(tester, container);
      
      // Verify error handling
      expect(token, isEmpty);
      
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.responseState, ResponseStates.failure);
      expect(authState.message, 'Verification failed');
      
      print('✓ Error handling working correctly');
    });
  });
}
