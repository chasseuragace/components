import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import 'helpers/test_helpers.dart';
import 'mocks/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Udaan Sarathi Authentication Logic Tests', () {
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

    test('User Registration Flow - New User Registration with OTP Verification', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Test user registration
      print('Testing user registration...');
      final otp = await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
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

    test('OTP Verification Flow - Verify OTP and Get Token', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // First register user
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      // Test OTP verification
      print('Testing OTP verification...');
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
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

    test('Existing User Login Flow - Login Start and Verify', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // First register user to simulate existing user
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      // Clear auth state to simulate logout
      await authController.logout();
      
      // Test login start
      print('Testing login start...');
      final loginOtp = await authController.loginStart(
        phone: userData['phone']!,
      );
      
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

    test('Session Persistence - Check Auth on Launch', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller and create session
      final authController = container.read(authControllerProvider.notifier);
      
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
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
      
      // Test session restoration
      print('Testing session persistence...');
      final newAuthController = newContainer.read(authControllerProvider.notifier);
      await newAuthController.checkAuthOnLaunch();
      
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

    test('Error Handling - Invalid OTP', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Register user first
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      // Test with invalid OTP
      print('Testing error handling with invalid OTP...');
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: 'wrong_otp',
      );
      
      // Verify error handling
      expect(token, isEmpty);
      
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.responseState, ResponseStates.failure);
      expect(authState.message, 'Verification failed');
      
      print('✓ Error handling working correctly');
    });

    test('Token Storage Integration', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Complete registration and verification
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
      // Test direct token storage access
      final storedToken = await tokenStorage.getToken();
      expect(storedToken, equals(token));
      
      final candidateId = await tokenStorage.getCandidateId();
      expect(candidateId, isNotNull);
      expect(candidateId, startsWith('candidate_'));
      
      // Test logout clears storage
      await authController.logout();
      
      final clearedToken = await tokenStorage.getToken();
      expect(clearedToken, isNull);
      
      final clearedCandidateId = await tokenStorage.getCandidateId();
      expect(clearedCandidateId, isNull);
      
      print('✓ Token storage integration working');
      print('✓ Logout properly clears stored data');
    });

    test('Concurrent Authentication Requests', () async {
      final userData = TestHelpers.createMockUserData();
      
      // Get auth controller
      final authController = container.read(authControllerProvider.notifier);
      
      // Test concurrent registration requests
      final futures = List.generate(3, (index) => 
        authController.register(
          fullName: '${userData['fullName']!}_$index',
          phone: '987654321$index',
        )
      );
      
      final otps = await Future.wait(futures);
      
      // Verify all requests completed successfully
      for (final otp in otps) {
        expect(otp, equals('123456'));
      }
      
      print('✓ Concurrent authentication requests handled correctly');
    });
  });
}
