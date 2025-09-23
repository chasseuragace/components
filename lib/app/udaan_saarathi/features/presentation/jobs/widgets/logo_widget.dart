import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/string_utils.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    required this.logoUrl,
    required this.companyName,
  });
  final String logoUrl;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: logoUrl.isEmpty
          ? Center(
              child: Text(
                companyName.companyInitial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : CachedNetworkImage(
              imageUrl: logoUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.business, color: Colors.grey),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                child: Text(companyName.companyInitial),
              ),
            ),
    );
  }
}
