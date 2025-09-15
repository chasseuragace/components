class CustomValidator {
  static String? nameValidator({String? input, required String type}) {
    if (input == null || input.trim().isEmpty) {
      return '$type is required.';
    }
    if (input.length < 2) {
      return 'Enter a valid $type';
    } else {
      return null;
    }
  }

  static String? priceValidator({String? input, required String type}) {
    if (input == null || input.isEmpty) {
      return "$type is required.";
    }
    final price = num.tryParse(input);
    if (price == null) {
      return "Enter a valid number.";
    }
    if (price <= 0) {
      return "Price must be greater than zero.";
    } else {
      return null;
    }
  }

  static String? emailValidator(
    String? input, {
    bool isRequired = true,
    String requiredMessage = 'Email is required.',
    String invalidEmailMessage = 'Enter a valid email.',
    String? customPattern,
  }) {
    if (input == null || input.trim().isEmpty) {
      return isRequired ? requiredMessage : null;
    }

    final emailPattern = customPattern ??
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"
            r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@'
            r"(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]"
            r"(?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|"
            r"1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|"
            r"1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:"
            r"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]"
            r"|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])";

    final regex = RegExp(emailPattern, caseSensitive: false);

    if (!regex.hasMatch(input.trim())) {
      return invalidEmailMessage;
    }

    return null;
  }

  static String? phoneValidator(String? input, {bool isRequired = false}) {
    if (input == null || input.trim().isEmpty) {
      return isRequired ? 'Phone is required.' : null;
    }

    // Normalize input
    input = input.trim();

    // Define regex patterns for each provider
    final ncellPattern = RegExp(r'^98[0-2][0-9]{7}$');
    final ntcPattern = RegExp(r'^98[4-6][0-9]{7}$');
    final ntcCdmaPattern = RegExp(r'^97[4-5][0-9]{7}$');
    final smartPattern = RegExp(r'^(96[0-9]{8}|988[0-9]{7})$');

    if (ncellPattern.hasMatch(input)) {
      return null;
    } else if (ntcPattern.hasMatch(input)) {
      return null;
    } else if (ntcCdmaPattern.hasMatch(input)) {
      return null;
    } else if (smartPattern.hasMatch(input)) {
      return null;
    }

    return 'Enter a valid nepali phone number.';
  }
}
