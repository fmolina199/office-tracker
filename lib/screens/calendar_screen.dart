import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_head.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_row.dart';
import 'package:office_tracker/widgets/calendar/widgets/weekdays_row.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static final _log = LoggingUtil('_CalendarScreenState');
  static DateTime getCurrentMonthDate() {
    final date = DateTime.now();
    return DateTime(
        date.year,
        date.month,
        1,
        12, // Setting time to noon is required for summer time transition
    );
  }

  static DateTime getFirstDayInCalendar(DateTime date, int firstWeekday) {
    while(date.weekday != firstWeekday) {
      date = date.subtract(oneDayDuration);
    }
    return date;
  }

  DateTime _selectedMonth = getCurrentMonthDate();


  void setNewSelectedMonth(DateTime date) {
    setState(() {
      _selectedMonth = date;
    });
  }

  void subtractOneMonth() {
    final date = DateTime(
      _selectedMonth.year,
      _selectedMonth.month-1,
      1,
      12, // Setting time to noon is required for summer time transition
    );
    setNewSelectedMonth(date);
  }

  void addOneMonth() {
    final date = DateTime(
      _selectedMonth.year,
      _selectedMonth.month+1,
      1,
      12, // Setting time to noon is required for summer time transition
    );
    setNewSelectedMonth(date);
  }

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');
    final presenceHistory = TrackerHistory<DateTime>();
    final settings = context.watch<SettingsCubit>().state;
    final firstWeekday = settings.firstWeekday;
    final List<int> weekdaysOff = settings.weekdaysOff;

    final firstDayCalendar = getFirstDayInCalendar(
      _selectedMonth,
      firstWeekday,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1000,
        maxHeight: 1000,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: formHorizontalPadding),
        child: Column(
          children: [
            CalendarHead(
              date: _selectedMonth,
              onClickLeftArrow: subtractOneMonth,
              onClickRightArrow: addOneMonth,
            ),
            Row(
              children: [
                Expanded(child: Container(height: formHorizontalPadding)),
              ],
            ),
            WeekdaysRow(firstWeekday: firstWeekday),
            CalendarRow(
              date: firstDayCalendar,
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 2),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 3),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 4),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 5),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
            ),
          ],
        ),
      ),
    );
  }


}
