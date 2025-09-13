class AuthState {
  final bool loading;
  final String? token;
  const AuthState({this.loading = false, this.token});

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({bool? loading, String? token}) =>
      AuthState(loading: loading ?? this.loading, token: token ?? this.token);

  static const unauthenticated = AuthState(loading: false, token: null);
}
