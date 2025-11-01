import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/base_entity.dart';

class OnboardingEntity extends BaseEntity {
  final String id;
  final String title;
  final String description;
  final IconData image;
  final Color primaryColor;
  final Color secondaryColor;

  OnboardingEntity({required this.id, 
    required this.title,
    required this.description,
    required this.image,
    required this.primaryColor,
    required this.secondaryColor,  super.rawJson=const {},
  });
}
