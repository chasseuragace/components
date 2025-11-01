import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import 'test_app.dart';
import 'helpers/test_helpers.dart';
import 'mocks/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Udaan Sarathi Profile Management Integration Tests', () {
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
      
      // Wait for authentication to complete
      await Future.delayed(const Duration(milliseconds: 100));
    }

    testWidgets('Profile Creation - Add Skills', (tester) async {
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
      
      // Wait for profile state to update
      await TestHelpers.waitForProfileState(tester, container);
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Skills added successfully');
      
      print('✓ Skills added successfully');
    });

    testWidgets('Profile Creation - Add Education', (tester) async {
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
      
      // Wait for profile state to update
      await TestHelpers.waitForProfileState(tester, container);
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Education added successfully');
      
      print('✓ Education added successfully');
    });

    testWidgets('Profile Creation - Add Work Experience', (tester) async {
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
      
      // Wait for profile state to update
      await TestHelpers.waitForProfileState(tester, container);
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Experience added successfully');
      
      print('✓ Work experience added successfully');
    });

    testWidgets('Profile Creation - Add Trainings', (tester) async {
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
      
      // Wait for profile state to update
      await TestHelpers.waitForProfileState(tester, container);
      
      // Verify profile state
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.success);
      expect(profileState.value!.message, 'Trainings added successfully');
      
      print('✓ Trainings added successfully');
    });

    testWidgets('Complete Profile Flow - Add All Profile Sections', (tester) async {
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
      await TestHelpers.waitForProfileState(tester, container);
      
      var profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 2. Add Education
      print('Adding education...');
      await profileNotifier.addEducation(
        List<Map<String, dynamic>>.from(profileData['education']),
      );
      await TestHelpers.waitForProfileState(tester, container);
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 3. Add Experience
      print('Adding experience...');
      await profileNotifier.addExperience(
        List<Map<String, dynamic>>.from(profileData['experience']),
      );
      await TestHelpers.waitForProfileState(tester, container);
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      // 4. Add Trainings
      print('Adding trainings...');
      await profileNotifier.addTrainings(
        List<Map<String, dynamic>>.from(profileData['trainings']),
      );
      await TestHelpers.waitForProfileState(tester, container);
      
      profileState = container.read(profileProvider);
      expect(profileState.value!.status, ResponseStates.success);
      
      print('✓ Complete profile created successfully');
      print('✓ All profile sections added');
      print('✓ Profile data linked to candidate ID');
    });

    testWidgets('Profile Error Handling - Unauthenticated User', (tester) async {
      // Launch the app without authentication
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

      // Verify user is not authenticated
      final authState = container.read(authControllerProvider);
      expect(authState.isAuthenticated, false);
      
      // Get profile provider
      final profileNotifier = container.read(profileProvider.notifier);
      final profileData = TestHelpers.createMockProfileData();
      
      // Test adding skills without authentication
      print('Testing profile creation without authentication...');
      await profileNotifier.addSkills(
        List<Map<String, dynamic>>.from(profileData['skills']),
      );
      
      // Wait for profile state to update
      await TestHelpers.waitForProfileState(tester, container);
      
      // Verify error handling
      final profileState = container.read(profileProvider);
      expect(profileState.hasValue, true);
      expect(profileState.value!.status, ResponseStates.failure);
      expect(profileState.value!.errorMessage, contains('Exception'));
      
      print('✓ Error handling working for unauthenticated users');
    });
  });
}
