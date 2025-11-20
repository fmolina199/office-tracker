import 'package:flutter/material.dart';
import 'package:office_tracker/constants/sizes.dart';

class LabeledMenu<T> extends StatelessWidget {
  final String text;
  final Widget child;

  const LabeledMenu({
    super.key,
    required this.text,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: betweenItemsSpace,
      children: [
        Expanded(
          flex: labelFlexValue,
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: defaultFontSize
            ),
          ),
        ),
        Expanded(
          flex: inputFlexValue,
          child: child,
        ),
      ],
    );
  }
}
