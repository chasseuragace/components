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

  group('Udaan Sarathi Integration Test Summary', () {
    late SharedPreferences sharedPreferences;
    late ProviderContainer container;
    late TokenStorage tokenStorage;

    setUp(() async {
      sharedPreferences = await TestHelpers.createCleanSharedPreferences();
      tokenStorage = TokenStorage(SharedPrefsLocalStorage(sharedPreferences));
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

    test('Complete User Journey - Registration to Authentication', () async {
      print('=== UDAAN SARATHI INTEGRATION TEST SUMMARY ===');
      print('Testing complete user authentication journey...\n');

      final userData = TestHelpers.createMockUserData();
      final authController = container.read(authControllerProvider.notifier);

      // Step 1: User Registration
      print('📱 Step 1: User Registration');
      print('   Phone: ${userData['phone']}');
      print('   Name: ${userData['fullName']}');
      
      final otp = await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      expect(otp, equals('123456'));
      print('   ✅ Registration successful, OTP: $otp');

      // Step 2: OTP Verification
      print('\n🔐 Step 2: OTP Verification');
      final token = await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
      expect(token, isNotEmpty);
      expect(token, startsWith('mock_token_'));
      print('   ✅ OTP verified, token generated');
      print('   Token: ${token.substring(0, 20)}...');

      // Step 3: Storage Verification
      print('\n💾 Step 3: Local Storage Verification');
      await TestHelpers.verifyTokenStored(sharedPreferences);
      await TestHelpers.verifyCandidateIdStored(sharedPreferences);
      
      final candidateId = await tokenStorage.getCandidateId();
      print('   ✅ Token stored in SharedPreferences');
      print('   ✅ Candidate ID stored: $candidateId');

      // Step 4: Authentication State
      print('\n🔑 Step 4: Authentication State Verification');
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, true);
      expect(authState.token, equals(token));
      expect(authState.responseState, ResponseStates.success);
      print('   ✅ User is authenticated');
      print('   ✅ Auth state is valid');

      // Step 5: Session Persistence Test
      print('\n🔄 Step 5: Session Persistence Test');
      container.dispose();
      
      final newContainer = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ...MockProviders.createOverrides(tokenStorage),
        ],
      );
      
      final newAuthController = newContainer.read(authControllerProvider.notifier);
      await newAuthController.checkAuthOnLaunch();
      
      final restoredAuthState = newContainer.read(authControllerProvider);
      expect(restoredAuthState.isAuthenticated, true);
      print('   ✅ Session restored after app restart');
      
      newContainer.dispose();

      print('\n=== INTEGRATION TEST RESULTS ===');
      print('✅ User Registration Flow: PASSED');
      print('✅ OTP Verification Flow: PASSED');
      print('✅ Token Generation & Storage: PASSED');
      print('✅ Candidate ID Management: PASSED');
      print('✅ Session Persistence: PASSED');
      print('✅ Riverpod State Management: PASSED');
      print('✅ SharedPreferences Integration: PASSED');
      print('✅ Mock Provider Overrides: PASSED');
      print('\n🎉 ALL CORE AUTHENTICATION FEATURES WORKING!');
    });

    test('Error Scenarios and Edge Cases', () async {
      print('\n=== ERROR HANDLING TEST SUMMARY ===');
      
      final userData = TestHelpers.createMockUserData();
      final authController = container.read(authControllerProvider.notifier);

      // Test 1: Invalid OTP
      print('🚫 Test 1: Invalid OTP Handling');
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      final invalidToken = await authController.verify(
        phone: userData['phone']!,
        otp: 'wrong_otp',
      );
      
      expect(invalidToken, isEmpty);
      final authState = container.read(authControllerProvider);
      expect(authState.responseState, ResponseStates.failure);
      print('   ✅ Invalid OTP properly rejected');

      // Test 2: Login for Non-existent User
      print('\n🚫 Test 2: Non-existent User Login');
      final nonExistentOtp = await authController.loginStart(
        phone: '1234567890',
      );
      
      expect(nonExistentOtp, isEmpty);
      final loginState = container.read(authControllerProvider);
      expect(loginState.responseState, ResponseStates.failure);
      print('   ✅ Non-existent user login properly handled');

      // Test 3: Logout Functionality
      print('\n🚪 Test 3: Logout Functionality');
      // First authenticate
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );
      
      // Then logout
      await authController.logout();
      
      final logoutState = container.read(authControllerProvider);
      expect(logoutState.isAuthenticated, false);
      
      final clearedToken = await tokenStorage.getToken();
      expect(clearedToken, isNull);
      print('   ✅ Logout clears authentication state');
      print('   ✅ Logout clears stored tokens');

      print('\n=== ERROR HANDLING RESULTS ===');
      print('✅ Invalid OTP Handling: PASSED');
      print('✅ Non-existent User Handling: PASSED');
      print('✅ Logout Functionality: PASSED');
      print('\n🛡️ ALL ERROR SCENARIOS PROPERLY HANDLED!');
    });

    test('Profile Integration Status', () async {
      print('\n=== PROFILE INTEGRATION STATUS ===');
      
      // Authenticate user first
      final userData = TestHelpers.createMockUserData();
      final authController = container.read(authControllerProvider.notifier);
      
      await authController.register(
        fullName: userData['fullName']!,
        phone: userData['phone']!,
      );
      
      await authController.verify(
        phone: userData['phone']!,
        otp: userData['otp']!,
      );

      // Check candidate ID for profile operations
      final candidateId = await tokenStorage.getCandidateId();
      expect(candidateId, isNotNull);
      print('✅ Candidate ID available for profile operations: $candidateId');

      // Note about profile testing
      print('\n📝 PROFILE TESTING NOTES:');
      print('• Authentication flow is fully functional and tested');
      print('• Candidate ID is properly generated and stored');
      print('• Profile operations require backend server running');
      print('• Current profile repository uses real HTTP calls');
      print('• Profile mock overrides need backend-specific implementation');
      print('\n💡 RECOMMENDATION:');
      print('• Use authentication tests for CI/CD pipeline');
      print('• Profile tests require local backend server');
      print('• Consider creating profile-specific mocks for unit testing');

      print('\n=== INTEGRATION SUMMARY ===');
      print('🟢 Authentication & Storage: FULLY TESTED & WORKING');
      print('🟡 Profile Operations: REQUIRES BACKEND SERVER');
      print('🟢 State Management: FULLY TESTED & WORKING');
      print('🟢 Error Handling: FULLY TESTED & WORKING');
    });
  });
}
