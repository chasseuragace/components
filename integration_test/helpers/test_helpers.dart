import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/profile_provider.dart';

/// Test utilities and helpers for integration tests
class TestHelpers {
  /// Creates a clean SharedPreferences instance for testing
  static Future<SharedPreferences> createCleanSharedPreferences() async {
    SharedPreferences.setMockInitialValues({});
    return await SharedPreferences.getInstance();
  }

  /// Waits for authentication state to change
  static Future<void> waitForAuthState(
    WidgetTester tester,
    ProviderContainer container, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pump();
    
    final completer = Completer<void>();
    late final ProviderSubscription subscription;
    
    subscription = container.listen(
      authControllerProvider,
      (previous, next) {
        if (!next.loading) {
          subscription.close();
          completer.complete();
        }
      },
    );

    await Future.any([
      completer.future,
      Future.delayed(timeout, () => throw TimeoutException('Auth state timeout', timeout)),
    ]);
    
    await tester.pumpAndSettle();
  }

  /// Waits for profile operation to complete
  static Future<void> waitForProfileState(
    WidgetTester tester,
    ProviderContainer container, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pump();
    
    final completer = Completer<void>();
    late final ProviderSubscription subscription;
    
    subscription = container.listen(
      profileProvider,
      (previous, next) {
        if (next.hasValue && next.value!.status != ResponseStates.loading) {
          subscription.close();
          completer.complete();
        }
      },
    );

    await Future.any([
      completer.future,
      Future.delayed(timeout, () => throw TimeoutException('Profile state timeout', timeout)),
    ]);
    
    await tester.pumpAndSettle();
  }

  /// Verifies token is stored in SharedPreferences
  static Future<void> verifyTokenStored(SharedPreferences prefs) async {
    final token = prefs.getString('auth_token');
    expect(token, isNotNull);
    expect(token, isNotEmpty);
  }

  /// Verifies candidate ID is stored in SharedPreferences  
  static Future<void> verifyCandidateIdStored(SharedPreferences prefs) async {
    final candidateId = prefs.getString('candidate_id');
    expect(candidateId, isNotNull);
    expect(candidateId, isNotEmpty);
  }

  /// Creates mock user data for testing
  static Map<String, dynamic> createMockUserData() {
    return {
      'fullName': 'Test User',
      'phone': '9876543210',
      'otp': '123456',
    };
  }

  /// Creates mock profile data for testing
  static Map<String, dynamic> createMockProfileData() {
    return {
      'skills': [
        {
          'title': 'Flutter Development',
          'duration_months': 24,
          'years': 2,
          'documents': ['cert1.pdf'],
        },
        {
          'title': 'Mobile App Development', 
          'duration_months': 12,
          'years': 1,
          'documents': [],
        }
      ],
      'education': [
        {
          'title': 'Bachelor of Computer Science',
          'institute': 'Test University',
          'degree': 'Bachelor',
          'document': 'degree.pdf',
        }
      ],
      'experience': [
        {
          'title': 'Software Developer',
          'employer': 'Test Company',
          'start_date_ad': '2022-01-01',
          'end_date_ad': '2024-01-01',
          'months': 24,
          'description': 'Developed mobile applications',
        }
      ],
      'trainings': [
        {
          'title': 'Advanced Flutter',
          'provider': 'Training Institute',
          'hours': 40,
          'certificate': true,
        }
      ],
    };
  }
}

/// Custom exception for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message (${timeout.inSeconds}s)';
}
