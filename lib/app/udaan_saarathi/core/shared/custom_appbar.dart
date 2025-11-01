import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class SarathiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;

  const SarathiAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation,
    this.color,
    this.bottom,
  });
  final double? elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(size: 22.w),
              // foregroundColor: AppColors.korange,
              // actionsIconTheme: const IconThemeData(
              //   color: AppColors.kblack,
              // ),
              titleTextStyle: TextStyle(
                fontSize: 18,
                color: AppColors.kblack,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          child: AppBar(
            leadingWidth: 40.w,
            backgroundColor: color ?? AppColors.kwhite,
            elevation: elevation ?? 0,
            actions: actions,
            centerTitle: centerTitle,
            leading: Container(
              child: leading ??
                  ((ModalRoute.of(context)!.canPop)
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 20.w,
                            color: AppColors.kblack,
                          ),
                          // replace with your own icon data.
                        )
                      : null),
            ),
            title: title,
            bottom: bottom,
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//TODO#:refactor
class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  const PersistentHeader({required this.widget});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      child: Container(
        width: double.infinity,
        // height: 56.0,
        color: AppColors.ktransparent,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
