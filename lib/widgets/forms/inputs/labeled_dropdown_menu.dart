import 'package:flutter/material.dart';
import 'package:office_tracker/constants/sizes.dart';

class LabeledDropdownMenu<T> extends StatelessWidget {
  final String text;
  final T initialSelection;
  final List<DropdownMenuEntry<T>> menuEntries;
  final ValueChanged<T?>? onSelected;

  const LabeledDropdownMenu({
    super.key,
    required this.text,
    required this.initialSelection,
    required this.menuEntries,
    this.onSelected,
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
          child: DropdownMenu<T>(
            expandedInsets: EdgeInsets.zero,
            initialSelection: initialSelection,
            onSelected: onSelected,
            dropdownMenuEntries: menuEntries,
          ),
        ),
      ],
    );
  }
}
