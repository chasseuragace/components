import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/models/job_title_models.dart';

class SelectedJobTitleCard extends StatelessWidget {
  const SelectedJobTitleCard({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
  });

  final JobTitleWithPriority item;
  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        border: Border(left: BorderSide(color: Color(0xFF1E88E5), width: 4)),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            // color: const Color(0xFF1E88E5),
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        title: Text(
          item.jobTitle.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          item.jobTitle.category,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.drag_handle, color: Color(0xFF94A3B8)),
            // const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                    const Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
