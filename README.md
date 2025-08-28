# variant_dashboard

A Flutter "variants playground" to design, build, and demo multiple page/component variants to clients. Once a client picks a preferred variant, we use it as the baseline for the actual application build.

## Overview

This workspace is intentionally optimized for fast iteration over UI ideas. Each screen can have several variants (V1, V2, V3, …). The app renders a dashboard that previews all variants in a consistent, mobile-like frame so stakeholders can compare and choose quickly.

## Project Structure

Key paths (Clean Architecture–inspired):

- `lib/app.dart`
  - App bootstrap (`MyApp`), theme wiring, home page.
- `lib/core/theme/app_theme.dart`
  - Centralized `ThemeData` and theme tokens.
- `lib/features/variants/`
  - `domain/entities/` → `VariantItem`, `VariantGroup`.
  - `presentation/pages/variant_dashboard_page.dart` → Lists groups and renders previews.
  - `presentation/widgets/variant_preview.dart` → Mobile frame preview for each variant.
  - `presentation/variants/` → Actual variant widgets grouped by feature area, e.g.:
    - `home/home_page_variant1.dart`, `home_page_variant2.dart`, `home_page_variant3.dart`
    - `settings/user_settings_variant1.dart`, `user_settings_variant2.dart`

## Run Locally

```bash
flutter pub get
flutter run
```

Tests:

```bash
flutter test -r compact
```

## Adding a New Variant

1) Create the variant widget

- Pick the appropriate feature folder under:
  - `lib/features/variants/presentation/variants/<feature>/`
- Add a new file, e.g. `home/home_page_variant4.dart`:

```dart
import 'package:flutter/material.dart';

class HomePageVariant4 extends StatelessWidget {
  const HomePageVariant4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page V4')),
      body: const Center(child: Text('New concept here')),
    );
  }
}
```

2) Register it on the dashboard

- Open `lib/features/variants/presentation/pages/variant_dashboard_page.dart`.
- Add an entry to the correct `VariantGroup`:

```dart
VariantItem(
  name: 'Home V4 - Concept',
  builder: (context) => const HomePageVariant4(),
),
```

The dashboard will now render your new card with a preview.

## Naming Conventions

- Use clear, incremental names: `FooVariant1`, `FooVariant2`, etc.
- Keep variant widgets stateless unless local UI state is necessary.
- Prefer small, focused widgets; pull shared pieces into small components if reused.

## Demo Tips

- Keep copy short and neutral; focus on layout and interaction.
- Use consistent seeding/colors via theme for fair comparisons.
- Add brief subtitles in the card name to highlight the concept difference.

## After Client Selection

1) Freeze the chosen variant(s) and move them into the real feature module(s).
2) Introduce data layer, navigation, and state management (e.g.,  `riverpod`) as needed.
3) Remove unselected variants from the dashboard to reduce noise.

## Requirements

- Flutter SDK (see `pubspec.yaml` for Dart SDK constraints).

## License

Private workspace. Do not distribute without permission.

