import 'package:flutter_test/flutter_test.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/candidate/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/validators/candidate_profile_validator.dart';

void main() {
  group('CandidateProfileValidator', () {
    late CandidateModel validCandidate;

    setUp(() {
      validCandidate = CandidateModel(
        id: 'test_candidate_123',
        fullName: 'John Doe',
        phone: '+9779876543210',
        gender: 'male',
        passportNumber: 'A1234567',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        rawJson: {},
      );
    });

    group('validate', () {
      test('should return empty list for valid candidate', () {
        final errors = CandidateProfileValidator.validate(validCandidate);
        expect(errors, isEmpty);
      });

      test('should return error for empty candidate ID', () {
        final candidate = CandidateModel(
          id: '',
          fullName: 'John Doe',
          phone: '+9779876543210',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Candidate ID is required'));
      });

      test('should return error for null full name', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: null,
          phone: '+9779876543210',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Full name is required'));
      });

      test('should return error for empty full name', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: '',
          phone: '+9779876543210',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Full name is required'));
      });

      test('should return error for too short full name', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'J',
          phone: '+9779876543210',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Full name must be at least 2 characters long'));
      });

      test('should return error for too long full name', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'A' * 101, // 101 characters
          phone: '+9779876543210',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Full name must not exceed 100 characters'));
      });

      test('should return error for null phone number', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: null,
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Phone number is required'));
      });

      test('should return error for empty phone number', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Phone number is required'));
      });

      test('should return error for invalid phone number format', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '123', // Too short
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Phone number format is invalid'));
      });

      test('should return error for invalid gender', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '+9779876543210',
          gender: 'invalid_gender',
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Gender must be one of: male, female, other, prefer_not_to_say'));
      });

      test('should accept valid gender values', () {
        final validGenders = ['male', 'female', 'other', 'prefer_not_to_say'];
        
        for (final gender in validGenders) {
          final candidate = CandidateModel(
            id: 'test_candidate_123',
            fullName: 'John Doe',
            phone: '+9779876543210',
            gender: gender,
            rawJson: {},
          );
          
          final errors = CandidateProfileValidator.validate(candidate);
          expect(errors.where((e) => e.contains('Gender')), isEmpty);
        }
      });

      test('should return error for too short passport number', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '+9779876543210',
          passportNumber: '1234', // Too short
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Passport number must be at least 5 characters long'));
      });

      test('should return error for too long passport number', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '+9779876543210',
          passportNumber: 'A' * 21, // Too long
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Passport number must not exceed 20 characters'));
      });

      test('should return error for invalid date relationship', () {
        final candidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '+9779876543210',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)), // Before created
          rawJson: {},
        );
        
        final errors = CandidateProfileValidator.validate(candidate);
        expect(errors, contains('Updated date cannot be before created date'));
      });
    });

    group('validateUpdate', () {
      late CandidateModel currentCandidate;
      late CandidateModel updatedCandidate;

      setUp(() {
        currentCandidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Doe',
          phone: '+9779876543210',
          gender: 'male',
          rawJson: {},
        );

        updatedCandidate = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Smith',
          phone: '+9779876543210',
          gender: 'male',
          rawJson: {},
        );
      });

      test('should return valid result for safe update', () {
        final result = CandidateProfileValidator.validateUpdate(currentCandidate, updatedCandidate);
        
        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
        expect(result.warnings, isEmpty);
      });

      test('should return error for ID change', () {
        final updatedWithNewId = CandidateModel(
          id: 'different_id',
          fullName: 'John Smith',
          phone: '+9779876543210',
          gender: 'male',
          rawJson: {},
        );
        
        final result = CandidateProfileValidator.validateUpdate(currentCandidate, updatedWithNewId);
        
        expect(result.isValid, isFalse);
        expect(result.errors, contains('Candidate ID cannot be changed'));
      });

      test('should return warning for phone number change', () {
        final updatedWithNewPhone = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John Smith',
          phone: '+9779876543211', // Different phone
          gender: 'male',
          rawJson: {},
        );
        
        final result = CandidateProfileValidator.validateUpdate(currentCandidate, updatedWithNewPhone);
        
        expect(result.isValid, isTrue);
        expect(result.warnings, contains('Phone number is being changed - this may affect authentication'));
      });

      test('should return warning for name shortening', () {
        final updatedWithShorterName = CandidateModel(
          id: 'test_candidate_123',
          fullName: 'John', // Shorter than 'John Doe'
          phone: '+9779876543210',
          gender: 'male',
          rawJson: {},
        );
        
        final result = CandidateProfileValidator.validateUpdate(currentCandidate, updatedWithShorterName);
        
        expect(result.isValid, isTrue);
        expect(result.warnings, contains('Full name is being shortened - please verify this is intentional'));
      });

      test('should return error for invalid updated candidate', () {
        final invalidUpdated = CandidateModel(
          id: 'test_candidate_123',
          fullName: '', // Invalid - empty name
          phone: '+9779876543210',
          gender: 'male',
          rawJson: {},
        );
        
        final result = CandidateProfileValidator.validateUpdate(currentCandidate, invalidUpdated);
        
        expect(result.isValid, isFalse);
        expect(result.errors, contains('Full name is required'));
      });
    });

    group('ValidationResult', () {
      test('should correctly identify when there are issues', () {
        final resultWithErrors = ValidationResult(
          isValid: false,
          errors: ['Error 1', 'Error 2'],
          warnings: [],
        );
        
        expect(resultWithErrors.hasIssues, isTrue);
        
        final resultWithWarnings = ValidationResult(
          isValid: true,
          errors: [],
          warnings: ['Warning 1'],
        );
        
        expect(resultWithWarnings.hasIssues, isTrue);
        
        final resultWithoutIssues = ValidationResult(
          isValid: true,
          errors: [],
          warnings: [],
        );
        
        expect(resultWithoutIssues.hasIssues, isFalse);
      });

      test('should format summary correctly', () {
        final result = ValidationResult(
          isValid: false,
          errors: ['Error 1', 'Error 2'],
          warnings: ['Warning 1'],
        );
        
        final summary = result.summary;
        expect(summary, contains('Errors: Error 1, Error 2'));
        expect(summary, contains('Warnings: Warning 1'));
      });
    });
  });
}
