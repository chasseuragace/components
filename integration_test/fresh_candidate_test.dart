import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import 'helpers/test_helpers.dart';

// Helper function to generate unique phone numbers for each test
String generateUniquePhone() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final lastDigits = timestamp.toString().substring(timestamp.toString().length - 7);
  return '987$lastDigits'; // Ensures 10-digit phone number
}

// Helper function to create a fresh candidate account
Future<Map<String, String>> createFreshCandidate({
  required ProviderContainer container,
  required String candidateName,
  String? customPhone,
}) async {
  final authController = container.read(authControllerProvider.notifier);
  
  // Generate unique phone or use custom one
  final phone = customPhone ?? generateUniquePhone();
  
  print('📱 Creating fresh candidate: $candidateName');
  print('📞 Phone: $phone');
  
  // Step 1: Register new candidate
  print('📝 Registering new candidate...');
  final registrationOtp = await authController.register(
    fullName: candidateName,
    phone: phone,
  );
  
  if (registrationOtp.isEmpty) {
    throw Exception('Registration failed - no OTP received');
  }
  
  print('✅ Registration successful - OTP: $registrationOtp');
  
  // Step 2: Verify registration OTP
  print('🔐 Verifying registration OTP...');
  final token = await authController.verify(
    phone: phone,
    otp: registrationOtp,
  );
  
  if (token.isEmpty) {
    throw Exception('Registration verification failed');
  }
  
  print('✅ Registration verification successful');
  print('🎫 Token received: ${token.substring(0, 20)}...');
  
  return {
    'phone': phone,
    'name': candidateName,
    'token': token,
    'registrationOtp': registrationOtp,
  };
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fresh Candidate Creation Tests', () {
    late SharedPreferences sharedPreferences;
    late ProviderContainer container;

    setUp(() async {
      // Create clean shared preferences for each test
      sharedPreferences = await TestHelpers.createCleanSharedPreferences();
      
      // Create provider container WITHOUT mock overrides - using real API
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          // No mock overrides - using real AuthRepositoryImpl
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await sharedPreferences.clear();
    });

    test('Create Fresh Candidate and Test Login Flow', () async {
      print('🚀 Testing Fresh Candidate Creation and Login Flow');
      
      // Step 1: Create fresh candidate account
      print('\n📝 Step 1: Creating Fresh Candidate Account...');
      final candidateData = await createFreshCandidate(
        container: container,
        candidateName: 'Fresh Test Candidate',
      );
      
      final testPhone = candidateData['phone']!;
      final testFullName = candidateData['name']!;
      
      print('✅ Fresh candidate created successfully');
      print('📱 Phone: $testPhone');
      print('👤 Name: $testFullName');
      
      // Step 2: Verify candidate ID is stored
      print('\n🔍 Step 2: Verifying Candidate ID Storage...');
      final tokenStorage = container.read(tokenStorageProvider);
      final candidateId = await tokenStorage.getCandidateId();
      
      expect(candidateId, isNotNull, reason: 'Candidate ID should be stored after registration');
      expect(candidateId, isNotEmpty, reason: 'Candidate ID should not be empty');
      
      print('✅ Candidate ID stored: $candidateId');
      
      // Step 3: Test Login Flow with fresh account
      print('\n🔑 Step 3: Testing Login Flow with Fresh Account...');
      final authController = container.read(authControllerProvider.notifier);
      
      final loginOtp = await authController.loginStart(phone: testPhone);
      expect(loginOtp, isNotEmpty, reason: 'Login OTP should be received');
      print('✅ Login start successful - OTP: $loginOtp');
      
      // Verify login OTP
      print('🔐 Verifying login OTP...');
      final loginToken = await authController.loginVerify(
        phone: testPhone,
        otp: loginOtp,
      );
      
      expect(loginToken, isNotEmpty, reason: 'Login token should be received');
      print('✅ Login verification successful');
      print('🎫 Login token received: ${loginToken.substring(0, 20)}...');
      
      // Step 4: Verify authentication state
      print('\n✅ Step 4: Verifying Authentication State...');
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, true, reason: 'User should be authenticated');
      expect(authState.token, isNotEmpty, reason: 'Token should be present');
      
      print('🎉 Fresh candidate creation and login flow test completed successfully!');
      print('📊 Summary:');
      print('   ✅ Fresh candidate registration');
      print('   ✅ Registration verification');
      print('   ✅ Candidate ID storage');
      print('   ✅ Login flow');
      print('   ✅ Authentication state management');
    });
  });
}
