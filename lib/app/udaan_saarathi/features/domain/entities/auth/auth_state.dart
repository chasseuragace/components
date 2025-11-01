import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';

class AuthState {
  final bool loading;
  final String? token;
  final String? message; // info/success message to show in UI
final ResponseStates responseState;
  const AuthState({
    this.loading = false,
    this.token,
    this.message,
    this.responseState = ResponseStates.initial,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    bool? loading,
    String? token,
    String? message,
    ResponseStates? responseState,
  }) =>
      AuthState(
        loading: loading ?? this.loading,
        token: token ?? this.token,
        message: message ?? this.message,
        responseState: responseState ?? this.responseState,
      );

  static const unauthenticated = AuthState(
    loading: false,
    token: null,
    message: null,
    responseState: ResponseStates.initial,
  );
}
