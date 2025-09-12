import '../../../data/datasources/onboarding/local_data_source.dart';
import '../../../data/datasources/onboarding/remote_data_source.dart';
import '../../../data/repositories/onboarding/repository_impl.dart';
import '../../../data/repositories/onboarding/repository_impl_fake.dart';
import '../../../domain/usecases/onboarding/get_all.dart';
import '../../../domain/usecases/onboarding/get_by_id.dart';
import '../../../domain/usecases/onboarding/add.dart';
import '../../../domain/usecases/onboarding/update.dart';
import '../../../domain/usecases/onboarding/delete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllOnboardingUseCaseProvider = Provider<GetAllOnboardingUseCase>((ref) {
  return GetAllOnboardingUseCase(ref.watch(rOnboardingRepositoryProvider));
});

final getOnboardingByIdUseCaseProvider = Provider<GetOnboardingByIdUseCase>((ref) {
  return GetOnboardingByIdUseCase(ref.watch(rOnboardingRepositoryProvider));
});

final addOnboardingUseCaseProvider = Provider<AddOnboardingUseCase>((ref) {
  return AddOnboardingUseCase(ref.watch(rOnboardingRepositoryProvider));
});

final updateOnboardingUseCaseProvider = Provider<UpdateOnboardingUseCase>((ref) {
  return UpdateOnboardingUseCase(ref.watch(rOnboardingRepositoryProvider));
});

final deleteOnboardingUseCaseProvider = Provider<DeleteOnboardingUseCase>((ref) {
  return DeleteOnboardingUseCase(ref.watch(rOnboardingRepositoryProvider));
});

final rOnboardingRepositoryProvider = Provider((ref) {
  final local = ref.read(localDataOnboardingSourceProvider);
  final remote = ref.read(remoteDataOnboardingSourceProvider);
  return OnboardingRepositoryFake(localDataSource: local, remoteDataSource: remote);
});

final localDataOnboardingSourceProvider = Provider<OnboardingLocalDataSource>((ref) {
  return OnboardingLocalDataSourceImpl();
});

final remoteDataOnboardingSourceProvider = Provider<OnboardingRemoteDataSource>((ref) {
  return OnboardingRemoteDataSourceImpl();
});
