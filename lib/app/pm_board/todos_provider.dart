import 'package:flutter_riverpod/flutter_riverpod.dart';

final todosProvider = StateProvider(
  (_) => [
    {
      "title": "Hookup the splash screen as the first page hte pm board  ",
      "description": "navigate to onboardinf after splash is done.",
      "subtasks": [],
    },
    {
      "title": "The Onboarding",
      "description": "This is introduction to unit testing  in flutter  ",
      "subtasks": [
        "json fields : image, title , description, ",
        "user cant skip onboarding midway",
        "app keeps record of the date when the last pnboarding was complete",
        "show onboarding again if n days passed since last onboarding",
        "create test cases",
      ],
    },
    {
      "title": "Create Home Page , Bottom Nav Bars (BNB)",
      "description": "Give the app a shape",
      "subtasks": [
        'insert any of the variant, preffed ones as per the meetign if possible for each BNB item',
      ],
    },
    {
      "title": "Create 'Preference' module using clean Arch ",
      "description":
          "All modules thereafter shall  follow hte architecuture you create, using the module mcp will be created fom your work  ",
      "subtasks": [
        "refer to file in 'simpler_generator_folders' in references"
            "use it once, make sure to commit before using",
        "update the clean arch gen's contet ",
        "skip hte presentation layer form the yaml maybe ?",
      ],
    },
  ],
);
