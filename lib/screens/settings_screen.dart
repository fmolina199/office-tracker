import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/menus.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/label_utils.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/forms/inputs/labeled_menu.dart';

class SettingsScreen extends StatelessWidget {
  static final _log = LoggingUtil('SettingsScreen');
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');

    final settings =  context.watch<SettingsCubit>().state;
    _log.debug('Settings: $settings');

    final int reportSize = settings.reportMonthSize;
    final int reportStartingMonth = settings.reportStartMonth;
    final int calendarFirstWeekday = settings.firstWeekday;
    final List<int> weekdaysOff = settings.weekdaysOff;

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
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    reportMonthSize: newValue ?? Settings.defaultReportSize
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'Starting Month:',
              child: DropdownSearch<int>(
                selectedItem: reportStartingMonth,
                items: (f, cs) => monthList,
                itemAsString: (item) => getMonthLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                   reportStartMonth: newValue ?? Settings.defaultStartMonth
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'First Weekday:',
              child: DropdownSearch<int>(
                selectedItem: calendarFirstWeekday,
                items: (f, cs) => weekdayList,
                itemAsString: (item) => getWeekdayLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    firstWeekday: newValue ?? Settings.defaultFirstWeekday
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'Weekdays Off:',
              child: DropdownSearch<int>.multiSelection(
                selectedItems: weekdaysOff,
                items: (f, cs) => weekdayList,
                itemAsString: (item) => getWeekdayLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    weekdaysOff: newValue
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
