import 'package:flutter/material.dart';

class WeekdayLabel extends StatelessWidget {
  final String text;

  const WeekdayLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        )
      )
    );
  }
}
