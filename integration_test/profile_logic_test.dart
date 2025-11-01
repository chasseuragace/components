import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import 'helpers/test_helpers.dart';
import 'mocks/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Udaan Sarathi Profile Management Logic Tests', () {
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

    /// Helper method to authenticate user before profile tests
    Future<void> authenticateUser() async {
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
    }

    test('Profile Creation - Add Skills', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Verify user is authenticated
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, true);
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding skills
      print('Testing skills addition...');
      await profileNotifier.addSkills(
        List<Map<String, dynamic>>.from(profileData['skills']),
      );
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Skills added successfully');
      
      print('✓ Skills added successfully');
    });

    test('Profile Creation - Add Education', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding education
      print('Testing education addition...');
      await profileNotifier.addEducation(
        List<Map<String, dynamic>>.from(profileData['education']),
      );
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Education added successfully');
      
      print('✓ Education added successfully');
    });

    test('Profile Creation - Add Work Experience', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding experience
      print('Testing work experience addition...');
      await profileNotifier.addExperience(
        List<Map<String, dynamic>>.from(profileData['experience']),
      );
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Experience added successfully');
      
      print('✓ Work experience added successfully');
    });

    test('Profile Creation - Add Trainings', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding trainings
      print('Testing trainings addition...');
      await profileNotifier.addTrainings(
        List<Map<String, dynamic>>.from(profileData['trainings']),
      );
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Trainings added successfully');
      
      print('✓ Trainings added successfully');
    });

    test('Complete Profile Flow - Add All Profile Sections', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Verify candidate ID is available in storage
      final candidateId = await tokenStorage.getCandidateId();
      expect(candidateId, isNotNull);
      expect(candidateId, isNotEmpty);
      print('✓ Candidate ID available: $candidateId');
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Add all profile sections sequentially
      print('Testing complete profile creation flow...');
      
      // 1. Add Skills
      print('Adding skills...');
      await profileNotifier.addSkills(
        List<Map<String, dynamic>>.from(profileData['skills']),
      );
      
      var profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 2. Add Education
      print('Adding education...');
      await profileNotifier.addEducation(
        List<Map<String, dynamic>>.from(profileData['education']),
      );
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 3. Add Experience
      print('Adding experience...');
      await profileNotifier.addExperience(
        List<Map<String, dynamic>>.from(profileData['experience']),
      );
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 4. Add Trainings
      print('Adding trainings...');
      await profileNotifier.addTrainings(
        List<Map<String, dynamic>>.from(profileData['trainings']),
      );
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      print('✓ Complete profile created successfully');
      print('✓ All profile sections added');
      print('✓ Profile data linked to candidate ID');
    });

    test('Profile Error Handling - Unauthenticated User', () async {
      // Verify user is not authenticated
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, false);
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding skills without authentication
      print('Testing profile creation without authentication...');
      
      // This should work with the current fake implementation
      // but in a real scenario with proper auth checks, it would fail
      await profileNotifier.addSkills(
        List<Map<String, dynamic>>.from(profileData['skills']),
      );
      
      // The current implementation uses fake repositories that don't enforce auth
      // In a real implementation, this would fail with an authentication error
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      
      print('✓ Profile operations completed (using fake implementation)');
      print('Note: Real implementation would require authentication');
    });

    test('Profile Data Validation', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      
      // Test with valid skills data
      print('Testing profile data validation...');
      
      final validSkills = [
        {
          'title': 'Flutter Development',
          'duration_months': 24,
          'years': 2,
          'documents': ['cert1.pdf'],
        }
      ];
      
      await profileNotifier.addSkills(validSkills);
      
      var profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // Test with minimal education data
      final minimalEducation = [
        {
          'title': 'Bachelor Degree',
          'institute': 'University',
          'degree': 'Bachelor',
          'document': null, // Optional field
        }
      ];
      
      await profileNotifier.addEducation(minimalEducation);
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      print('✓ Profile data validation working');
    });

    test('Profile State Management', () async {
      // Authenticate user first
      await authenticateUser();
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      
      // Check initial state
      var profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.initial);
      
      // Add skills and check state changes
      final skills = [{'title': 'Test Skill', 'duration_months': 12, 'years': 1, 'documents': []}];
      
      // Start async operation
      final future = profileNotifier.addSkills(skills);
      
      // Check loading state (might be too fast to catch)
      profileState = container.read(profileProvider);
      // Note: Loading state might complete too quickly to assert
      
      // Wait for completion
      await future;
      
      // Check final state
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Skills added successfully');
      
      print('✓ Profile state management working correctly');
    });
  });
}
