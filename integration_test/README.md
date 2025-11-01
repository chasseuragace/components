# Udaan Sarathi Integration Tests

This directory contains integration tests for the Udaan Sarathi Flutter application, focusing on authentication flow and profile management without UI testing.

## Test Structure

### Core Components

- **`test_app.dart`** - Test app wrapper that provides mock dependencies
- **`helpers/test_helpers.dart`** - Utility functions for test setup and assertions
- **`mocks/mock_providers.dart`** - Mock implementations of repositories and providers

### Test Suites

#### 1. Authentication Flow Tests (`auth_flow_test.dart`)

Tests the complete authentication flow including:

- **User Registration Flow**
  - New user registration with phone and full name
  - OTP generation and verification
  - Token generation and storage

- **OTP Verification Flow**
  - OTP validation
  - JWT token creation
  - Candidate ID generation and storage

- **Existing User Login Flow**
  - Login start (OTP request)
  - Login verification
  - Session restoration

- **Session Persistence**
  - Token storage in SharedPreferences
  - Session restoration on app restart
  - Automatic authentication check

- **Error Handling**
  - Invalid OTP scenarios
  - Network failure simulation
  - Proper error state management

#### 2. Profile Management Tests (`profile_flow_test.dart`)

Tests profile creation and management:

- **Individual Profile Sections**
  - Skills addition
  - Education history
  - Work experience
  - Training certifications

- **Complete Profile Flow**
  - Sequential addition of all profile sections
  - Candidate ID verification
  - Data persistence validation

- **Error Scenarios**
  - Unauthenticated profile creation attempts
  - Invalid data handling

## Key Features Tested

### 1. Riverpod State Management
- Provider initialization and dependency injection
- State changes and notifications
- Provider overrides for testing

### 2. Local Storage Integration
- SharedPreferences for token storage
- Candidate ID persistence
- Session management

### 3. Authentication Flow
- Registration → OTP → Verification → Token
- Login → OTP → Verification → Token
- Session restoration and persistence

### 4. Profile Management
- Authenticated profile operations
- Data validation and storage
- Error handling for unauthorized access

## Running the Tests

### Prerequisites

1. Ensure all dependencies are installed:
```bash
flutter pub get
```

2. Make sure you have the following dev dependencies in `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.9
```

### Running Individual Test Suites

```bash
# Run authentication flow tests
flutter test integration_test/auth_flow_test.dart

# Run profile management tests
flutter test integration_test/profile_flow_test.dart
```

### Running All Integration Tests

```bash
# Run all integration tests
flutter test integration_test/test_runner.dart

# Run with verbose output
flutter test integration_test/test_runner.dart --verbose
```

### Running on Specific Devices

```bash
# Run on connected device
flutter test integration_test/test_runner.dart -d <device_id>

# Run on iOS simulator
flutter test integration_test/test_runner.dart -d ios

# Run on Android emulator
flutter test integration_test/test_runner.dart -d android
```

## Test Data

The tests use mock data defined in `TestHelpers.createMockUserData()` and `TestHelpers.createMockProfileData()`:

### Mock User Data
```dart
{
  'fullName': 'Test User',
  'phone': '9876543210',
  'otp': '123456',
}
```

### Mock Profile Data
```dart
{
  'skills': [...],
  'education': [...],
  'experience': [...],
  'trainings': [...],
}
```

## Mock Implementations

### AuthRepository Mock
- Simulates backend API calls with network delays
- Fixed OTP: `123456` for all tests
- Generates mock JWT tokens
- Handles user registration and login flows

### Storage Mock
- Uses SharedPreferences with mock initial values
- Stores authentication tokens and candidate IDs
- Simulates local storage persistence

## Test Assertions

### Authentication Tests Verify:
- ✅ OTP generation and delivery
- ✅ Token creation and storage
- ✅ Candidate ID generation
- ✅ Session persistence across app restarts
- ✅ Error handling for invalid credentials

### Profile Tests Verify:
- ✅ Profile data creation for authenticated users
- ✅ Data linking to candidate ID
- ✅ Sequential profile section addition
- ✅ Error handling for unauthenticated access

## Integration with Backend

These tests use mock implementations but follow the same interfaces as the real backend integration. The mock responses simulate:

- Network delays (500ms for auth operations, 300ms for profile operations)
- Realistic error scenarios
- Proper data flow through the application layers

## Debugging Tests

### Enable Verbose Logging
Add print statements in tests to track execution:
```dart
print('✓ User registration successful');
print('✓ Token stored in local storage');
```

### Check Test State
Use container.read() to inspect provider states:
```dart
final authState = container.read(authControllerProvider);
print('Auth State: ${authState.isAuthenticated}');
```

### Verify Storage
Check SharedPreferences directly:
```dart
final token = sharedPreferences.getString('auth_token');
print('Stored Token: $token');
```

## Best Practices

1. **Clean State**: Each test starts with clean SharedPreferences
2. **Proper Teardown**: Dispose containers and clear storage after tests
3. **Realistic Timing**: Use appropriate delays to simulate network calls
4. **Error Coverage**: Test both success and failure scenarios
5. **State Verification**: Assert both UI state and storage state

## Troubleshooting

### Common Issues

1. **Provider Not Found**: Ensure all required providers are overridden in test setup
2. **State Not Updating**: Use `TestHelpers.waitForAuthState()` to wait for async operations
3. **Storage Issues**: Verify SharedPreferences is properly mocked and cleared between tests
4. **Timeout Errors**: Increase timeout duration for slower operations

### Debug Commands

```bash
# Run with debug output
flutter test integration_test/auth_flow_test.dart --verbose

# Run single test
flutter test integration_test/auth_flow_test.dart --name "User Registration Flow"
```

## Future Enhancements

- Add performance benchmarking
- Include network failure simulation
- Add data validation tests
- Implement test coverage reporting
- Add CI/CD integration
