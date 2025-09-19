  import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Udaan Sarathi",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          "Udaan Sarathi – Guiding Nepali Talent to Global Success.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
