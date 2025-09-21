import '../entities/candidate/entity.dart';

/// Validator for candidate profile data
class CandidateProfileValidator {
  /// Validates a candidate profile entity
  /// Returns a list of validation errors, empty if valid
  static List<String> validate(CandidateEntity candidate) {
    final errors = <String>[];

    // Validate required fields
    if (candidate.id.isEmpty) {
      errors.add('Candidate ID is required');
    }

    if (candidate.fullName == null || candidate.fullName!.trim().isEmpty) {
      errors.add('Full name is required');
    } else if (candidate.fullName!.length < 2) {
      errors.add('Full name must be at least 2 characters long');
    } else if (candidate.fullName!.length > 100) {
      errors.add('Full name must not exceed 100 characters');
    }

    if (candidate.phone == null || candidate.phone!.trim().isEmpty) {
      errors.add('Phone number is required');
    } else if (!_isValidPhoneNumber(candidate.phone!)) {
      errors.add('Phone number format is invalid');
    }

    // Validate optional fields
    if (candidate.passportNumber != null && candidate.passportNumber!.isNotEmpty) {
      if (candidate.passportNumber!.length < 5) {
        errors.add('Passport number must be at least 5 characters long');
      } else if (candidate.passportNumber!.length > 20) {
        errors.add('Passport number must not exceed 20 characters');
      }
    }

    if (candidate.gender != null && candidate.gender!.isNotEmpty) {
      final validGenders = ['male', 'female', 'other', 'prefer_not_to_say'];
      if (!validGenders.contains(candidate.gender!.toLowerCase())) {
        errors.add('Gender must be one of: ${validGenders.join(', ')}');
      }
    }

    // Validate address if provided
    if (candidate.address != null) {
      final addressErrors = _validateAddress(candidate.address!);
      errors.addAll(addressErrors);
    }

    // Validate dates
    if (candidate.createdAt != null && candidate.updatedAt != null) {
      if (candidate.updatedAt!.isBefore(candidate.createdAt!)) {
        errors.add('Updated date cannot be before created date');
      }
    }

    return errors;
  }

  /// Validates address entity
  static List<String> _validateAddress(dynamic address) {
    final errors = <String>[];

    // Note: This is a simplified validation
    // In a real application, you'd want more comprehensive address validation
    if (address.name != null && address.name!.trim().isEmpty) {
      errors.add('Address name cannot be empty if provided');
    }

    if (address.province != null && address.province!.trim().isEmpty) {
      errors.add('Province cannot be empty if provided');
    }

    if (address.district != null && address.district!.trim().isEmpty) {
      errors.add('District cannot be empty if provided');
    }

    return errors;
  }

  /// Validates phone number format
  static bool _isValidPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's a valid length (typically 10-15 digits)
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return false;
    }

    // Check if it starts with a valid country code or local number
    // This is a simplified validation - in production you'd want more comprehensive checks
    return true;
  }

  /// Validates if a candidate profile update is safe to perform
  static ValidationResult validateUpdate(CandidateEntity current, CandidateEntity updated) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check if critical fields are being changed
    if (current.id != updated.id) {
      errors.add('Candidate ID cannot be changed');
    }

    if (current.phone != updated.phone) {
      warnings.add('Phone number is being changed - this may affect authentication');
    }

    // Validate the updated entity
    final validationErrors = validate(updated);
    errors.addAll(validationErrors);

    // Check for suspicious changes
    if (current.fullName != updated.fullName && 
        updated.fullName != null && 
        current.fullName != null &&
        updated.fullName!.length < current.fullName!.length) {
      warnings.add('Full name is being shortened - please verify this is intentional');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}

/// Result of profile validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });

  /// Returns true if there are any errors or warnings
  bool get hasIssues => errors.isNotEmpty || warnings.isNotEmpty;

  /// Returns a formatted summary of all issues
  String get summary {
    final issues = <String>[];
    
    if (errors.isNotEmpty) {
      issues.add('Errors: ${errors.join(', ')}');
    }
    
    if (warnings.isNotEmpty) {
      issues.add('Warnings: ${warnings.join(', ')}');
    }
    
    return issues.join(' | ');
  }
}
