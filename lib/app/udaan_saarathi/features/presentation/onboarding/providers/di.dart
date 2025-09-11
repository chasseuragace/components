import '../../../data/datasources/Onboarding/local_data_source.dart';
import '../../../data/datasources/Onboarding/remote_data_source.dart';
import '../../../data/repositories/Onboarding/repository_impl.dart';
import '../../../data/repositories/Onboarding/repository_impl_fake.dart';
import '../../../domain/usecases/Onboarding/get_all.dart';
import '../../../domain/usecases/Onboarding/get_by_id.dart';
import '../../../domain/usecases/Onboarding/add.dart';
import '../../../domain/usecases/Onboarding/update.dart';
import '../../../domain/usecases/Onboarding/delete.dart';
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
