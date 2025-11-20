import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:office_tracker/constants/menus.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/utils/label_utils.dart';
import 'package:office_tracker/widgets/forms/inputs/labeled_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

const height = 48.0;
class _SettingsScreenState extends State<SettingsScreen> {
  int reportSize = 1;
  int reportStartingMonth = DateTime.january;
  int calendarFirstWeekday = DateTime.sunday;
  List<int> weekdaysOff = Settings.defaultWeekdaysOff;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 600,
      ),
      child: Padding(
        padding: const EdgeInsets.all(formHorizontalPadding),
        child: Column(
          spacing: betweenItemsSpace,
          children: [
            LabeledMenu(
              text: 'Report Size:',
              child: DropdownSearch<int>(
                selectedItem: reportSize,
                items: (f, cs) => reportSizeList,
                itemAsString: (item) => getReportSizeLabel(item),
                onSaved: (newValue) => reportSize = newValue ?? 1,
              ),
            ),
            LabeledMenu(
              text: 'Starting Month:',
              child: DropdownSearch<int>(
                selectedItem: reportStartingMonth,
                items: (f, cs) => monthList,
                itemAsString: (item) => getMonthLabel(item),
                onSaved: (newValue) => reportStartingMonth = newValue ?? DateTime.january,
              ),
            ),
            LabeledMenu(
              text: 'First Weekday:',
              child: DropdownSearch<int>(
                selectedItem: calendarFirstWeekday,
                items: (f, cs) => weekdayList,
                itemAsString: (item) => getWeekdayLabel(item),
                onSaved: (newValue) => calendarFirstWeekday = newValue ?? DateTime.sunday,
              ),
            ),
            LabeledMenu(
                text: 'Weekdays Off:',
                child: DropdownSearch<int>.multiSelection(
                  selectedItems: weekdaysOff,
                  items: (f, cs) => weekdayList,
                  itemAsString: (item) => getWeekdayLabel(item),
                  onSaved: (newValue) => weekdaysOff = newValue ?? Settings.defaultWeekdaysOff,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
