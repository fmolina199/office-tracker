import 'package:flutter/material.dart';
import 'package:office_tracker/constants/menus.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/widgets/forms/inputs/labeled_dropdown_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

const height = 48.0;
class _SettingsScreenState extends State<SettingsScreen> {
  int reportSize = reportSizes.first.value;
  int reportStartingMonth = months.first.value;
  int calendarFirstWeekDay = weekDays.first.value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: Padding(
        padding: const EdgeInsets.all(formHorizontalPadding),
        child: Column(
          spacing: betweenItemsSpace,
          children: [
            LabeledDropdownMenu(
                text: 'Report Size:',
                initialSelection: reportSize,
                menuEntries: reportSizes
            ),
            LabeledDropdownMenu(
                text: 'Starting Month:',
                initialSelection: reportStartingMonth,
                menuEntries: months
            ),
            LabeledDropdownMenu(
                text: 'First Week Day:',
                initialSelection: calendarFirstWeekDay,
                menuEntries: weekDays
            ),
          ],
        ),
      ),
    );
  }
}
