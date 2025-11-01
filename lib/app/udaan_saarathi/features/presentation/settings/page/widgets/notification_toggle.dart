import 'package:flutter/material.dart';

class NotificationToggle extends StatefulWidget {
  final String title;
  final bool initialValue;

  const NotificationToggle(this.title, this.initialValue, {super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Switch(
        value: isEnabled,
        onChanged: (value) {
          setState(() {
            isEnabled = value;
          });
        },
      ),
    );
  }
}
