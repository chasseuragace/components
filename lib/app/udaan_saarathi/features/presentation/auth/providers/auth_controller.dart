import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/usecases/usecase.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/auth/auth_state.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/get_token.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/login_start.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/login_verify.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/logout.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/register.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/usecases/auth/verify.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/di.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final registerUC = ref.watch(registerCandidateUseCaseProvider);
  final verifyUC = ref.watch(verifyCandidateUseCaseProvider);
  final loginStartUC = ref.watch(loginStartUseCaseProvider);
  final loginVerifyUC = ref.watch(loginVerifyUseCaseProvider);
  final getTokenUC = ref.watch(getTokenUseCaseProvider);
  final logoutUC = ref.watch(logoutUseCaseProvider);
  return AuthController(
    registerUC: registerUC,
    verifyUC: verifyUC,
    loginStartUC: loginStartUC,
    loginVerifyUC: loginVerifyUC,
    getTokenUC: getTokenUC,
    logoutUC: logoutUC,
  );
});

class AuthController extends StateNotifier<AuthState> {
  final RegisterCandidateUseCase registerUC;
  final VerifyCandidateUseCase verifyUC;
  final LoginStartUseCase loginStartUC;
  final LoginVerifyUseCase loginVerifyUC;
  final GetTokenUseCase getTokenUC;
  final LogoutUseCase logoutUC;

  AuthController({
    required this.registerUC,
    required this.verifyUC,
    required this.loginStartUC,
    required this.loginVerifyUC,
    required this.getTokenUC,
    required this.logoutUC,
  }) : super(AuthState.unauthenticated);

  Future<void> checkAuthOnLaunch() async {
    final result = await getTokenUC(NoParm());
    result.fold(
      (_) => state = AuthState.unauthenticated,
      (token) {
        if (token != null && token.isNotEmpty) {
          state = state.copyWith(
              token: token,
              loading: false,
              responseState: ResponseStates.success,
              message: 'Session restored');
        } else {
          state = AuthState.unauthenticated;
        }
      },
    );
  }

  Future<String> register(
      {required String fullName, required String phone}) async {
    state = state.copyWith(
        loading: true, responseState: ResponseStates.loading, message: null);
    try {
      final Either<Failure, String> res =
          await registerUC(RegisterParams(fullName: fullName, phone: phone));
      return res.fold(
        (l) {
          state = state.copyWith(
              responseState: ResponseStates.failure,
              message: 'Registration failed');
          return '';
        },
        (otp) {
          state = state.copyWith(
              responseState: ResponseStates.success,
              message: 'OTP sent successfully');
          return otp;
        },
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> verify({required String phone, required String otp}) async {
    state = state.copyWith(
        loading: true, responseState: ResponseStates.loading, message: null);
    try {
      final res = await verifyUC(VerifyParams(phone: phone, otp: otp));
      return res.fold(
        (l) {
          state = state.copyWith(
              responseState: ResponseStates.failure,
              message: 'Verification failed');
          return '';
        },
        (token) {
          state = state.copyWith(
              token: token,
              loading: false,
              responseState: ResponseStates.success,
              message: 'Verified');
          return token;
        },
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> loginStart({required String phone}) async {
    state = state.copyWith(
        loading: true, responseState: ResponseStates.loading, message: null);
    try {
      final res = await loginStartUC(LoginStartParams(phone: phone));
      return res.fold(
        (l) {
          state = state.copyWith(
              responseState: ResponseStates.failure,
              message: 'Failed to start login');
          return '';
        },
        (otp) {
          state = state.copyWith(
              message: 'OTP sent', responseState: ResponseStates.success);
          return otp;
        },
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<String> loginVerify(
      {required String phone, required String otp}) async {
    state = state.copyWith(
        loading: true, responseState: ResponseStates.loading, message: null);
    try {
      final res =
          await loginVerifyUC(LoginVerifyParams(phone: phone, otp: otp));
      return res.fold(
        (l) {
          state = state.copyWith(
              responseState: ResponseStates.failure,
              message: 'Login verification failed');
          return '';
        },
        (token) {
          state = state.copyWith(
              token: token,
              loading: false,
              responseState: ResponseStates.success,
              message: 'Welcome back');
          return token;
        },
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> logout() async {
    await logoutUC(NoParm());
    state = AuthState.unauthenticated.copyWith(message: 'Logged out');
  }
}
