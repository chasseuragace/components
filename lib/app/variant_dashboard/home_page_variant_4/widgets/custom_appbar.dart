import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom AppBar widget implementing Contemporary Professional Minimalism
/// Provides clean, content-focused design with professional blue accents
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// Search-focused app bar with search field
  search,

  /// Profile app bar with user avatar and settings
  profile,

  /// Back navigation app bar for detail screens
  back,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The variant of the app bar to display
  final CustomAppBarVariant variant;

  /// The title text to display (required for standard and back variants)
  final String? title;

  /// Whether to show the back button (optional, auto-detected for back variant)
  final bool? showBackButton;

  /// List of action widgets to display on the right side (optional)
  final List<Widget>? actions;

  /// Search hint text for search variant (optional)
  final String? searchHint;

  /// Search callback for search variant (optional)
  final ValueChanged<String>? onSearchChanged;

  /// Profile image URL for profile variant (optional)
  final String? profileImageUrl;

  /// Profile tap callback for profile variant (optional)
  final VoidCallback? onProfileTap;

  /// Whether to show elevation shadow (optional, defaults to true)
  final bool showElevation;

  /// Custom background color (optional, uses theme default)
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.variant,
    this.title,
    this.showBackButton,
    this.actions,
    this.searchHint,
    this.onSearchChanged,
    this.profileImageUrl,
    this.onProfileTap,
    this.showElevation = true,
    this.backgroundColor,
  });

  /// Factory constructor for standard app bar
  factory CustomAppBar.standard({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showElevation = true,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.standard,
      title: title,
      actions: actions,
      showElevation: showElevation,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for search app bar
  factory CustomAppBar.search({
    Key? key,
    String? searchHint,
    ValueChanged<String>? onSearchChanged,
    List<Widget>? actions,
    bool showElevation = true,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.search,
      searchHint: searchHint ?? 'Search jobs...',
      onSearchChanged: onSearchChanged,
      actions: actions,
      showElevation: showElevation,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for profile app bar
  factory CustomAppBar.profile({
    Key? key,
    String? profileImageUrl,
    VoidCallback? onProfileTap,
    List<Widget>? actions,
    bool showElevation = true,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.profile,
      profileImageUrl: profileImageUrl,
      onProfileTap: onProfileTap,
      actions: actions,
      showElevation: showElevation,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for back navigation app bar
  factory CustomAppBar.back({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showElevation = true,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.back,
      title: title,
      showBackButton: true,
      actions: actions,
      showElevation: showElevation,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: showElevation ? 2.0 : 0.0,
      shadowColor: theme.appBarTheme.shadowColor,
      systemOverlayStyle: theme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      centerTitle: false,
      automaticallyImplyLeading: _shouldShowBackButton(context),
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
      titleSpacing: _shouldShowBackButton(context) ? 0 : 16,
    );
  }

  /// Determines if back button should be shown
  bool _shouldShowBackButton(BuildContext context) {
    if (variant == CustomAppBarVariant.back) return true;
    if (showBackButton != null) return showBackButton!;
    return Navigator.of(context).canPop();
  }

  /// Builds the leading widget based on variant
  Widget? _buildLeading(BuildContext context) {
    if (variant == CustomAppBarVariant.profile) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onProfileTap?.call();
          },
          child: CircleAvatar(
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : null,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(26),
            child: profileImageUrl == null
                ? Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ),
      );
    }

    if (_shouldShowBackButton(context)) {
      return IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
      );
    }

    return null;
  }

  /// Builds the title widget based on variant
  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.back:
        return Text(
          title ?? '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.appBarTheme.foregroundColor,
          ),
        );

      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(77),
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onSearchChanged,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: searchHint ?? 'Search jobs...',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          ),
        );

      case CustomAppBarVariant.profile:
        return Text(
          'Job Portal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.appBarTheme.foregroundColor,
          ),
        );
    }
  }

  /// Builds the actions list with default navigation actions
  List<Widget>? _buildActions(BuildContext context) {
    final List<Widget> actionsList = [];

    // Add custom actions if provided
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    // Add default actions based on variant
    switch (variant) {
      case CustomAppBarVariant.standard:
        actionsList.add(
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/job-dashboard-screen');
            },
            icon: const Icon(Icons.dashboard),
            tooltip: 'Dashboard',
          ),
        );
        break;

      case CustomAppBarVariant.search:
        actionsList.add(
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Show filter bottom sheet
              _showFilterBottomSheet(context);
            },
            icon: const Icon(Icons.tune),
            tooltip: 'Filters',
          ),
        );
        break;

      case CustomAppBarVariant.profile:
        actionsList.addAll([
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Show notifications
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Show settings
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ]);
        break;

      case CustomAppBarVariant.back:
        // No default actions for back variant
        break;
    }

    return actionsList.isNotEmpty ? actionsList : null;
  }

  /// Shows filter bottom sheet for search variant
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Filter Jobs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Filter options will be implemented here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
