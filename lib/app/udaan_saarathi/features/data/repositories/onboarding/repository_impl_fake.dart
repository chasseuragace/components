import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/onboarding/entity.dart';
import '../../../domain/repositories/onboarding/repository.dart';
import '../../datasources/onboarding/local_data_source.dart';
import '../../datasources/onboarding/remote_data_source.dart';

// Fake data for Onboardings
final remoteItems = [
  OnboardingEntity(
    id: "_",
    title: "Welcome to Udaan Sarathi",
    description:
        "Your journey companion that helps you soar high and achieve your dreams with confidence and guidance.",
    image: Icons.flight_takeoff,
    primaryColor: const Color(0xFF6366F1),
    secondaryColor: const Color(0xFF8B5CF6),
  ),
  OnboardingEntity(
    id: "_",
    title: "Navigate Your Path",
    description:
        "Discover personalized routes to success with smart recommendations and expert insights tailored just for you.",
    image: Icons.explore,
    primaryColor: const Color(0xFF06B6D4),
    secondaryColor: const Color(0xFF0EA5E9),
  ),
  OnboardingEntity(
    id: "_",
    title: "Achieve Together",
    description:
        "Join a community of achievers and unlock your potential with collaborative tools and shared experiences.",
    image: Icons.groups,
    primaryColor: const Color(0xFF10B981),
    secondaryColor: const Color(0xFF059669),
  ),
];

class OnboardingRepositoryFake implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<OnboardingEntity>>> getAllItems() async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, OnboardingEntity?>> getItemById(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final remoteItem = remoteItems.firstWhere((item) => item.id == id,
          orElse: () => throw "Not found");
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(OnboardingEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(OnboardingEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
