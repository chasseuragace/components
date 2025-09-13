import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/auth_repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/auth/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  AuthController(this._repo) : super(AuthState.unauthenticated);

  Future<void> checkAuthOnLaunch() async {
    final token = await _repo.getToken();
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(token: token, loading: false);
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<String> register({required String fullName, required String phone}) async {
    state = state.copyWith(loading: true);
    try {
      final devOtp = await _repo.registerCandidate(fullName: fullName, phone: phone);
      return devOtp;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> verify({required String phone, required String otp}) async {
    state = state.copyWith(loading: true);
    try {
      final token = await _repo.verifyCandidate(phone: phone, otp: otp);
      state = state.copyWith(token: token, loading: false);
      return token;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> loginStart({required String phone}) async {
    state = state.copyWith(loading: true);
    try {
      final devOtp = await _repo.loginStart(phone: phone);
      return devOtp;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> loginVerify({required String phone, required String otp}) async {
    state = state.copyWith(loading: true);
    try {
      final token = await _repo.loginVerify(phone: phone, otp: otp);
      state = state.copyWith(token: token, loading: false);
      return token;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState.unauthenticated;
  }
}
