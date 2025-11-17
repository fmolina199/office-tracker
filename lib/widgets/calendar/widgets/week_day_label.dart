import 'package:flutter/material.dart';

class WeekDayLabel extends StatelessWidget {
  final String text;

  const WeekDayLabel({
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
