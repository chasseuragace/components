import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/auth/repository.dart' as domain;
import '../../../domain/usecases/auth/register.dart';
import '../../../domain/usecases/auth/verify.dart';
import '../../../domain/usecases/auth/login_start.dart';
import '../../../domain/usecases/auth/login_verify.dart';
import '../../../domain/usecases/auth/get_token.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../data/repositories/auth/auth_repository.dart';

final authRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final registerCandidateUseCaseProvider = Provider<RegisterCandidateUseCase>((ref) {
  return RegisterCandidateUseCase(ref.watch(authRepositoryProvider));
});

final verifyCandidateUseCaseProvider = Provider<VerifyCandidateUseCase>((ref) {
  return VerifyCandidateUseCase(ref.watch(authRepositoryProvider));
});

final loginStartUseCaseProvider = Provider<LoginStartUseCase>((ref) {
  return LoginStartUseCase(ref.watch(authRepositoryProvider));
});

final loginVerifyUseCaseProvider = Provider<LoginVerifyUseCase>((ref) {
  return LoginVerifyUseCase(ref.watch(authRepositoryProvider));
});

final getTokenUseCaseProvider = Provider<GetTokenUseCase>((ref) {
  return GetTokenUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});
