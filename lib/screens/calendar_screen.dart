import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/state_management/presence_history_cubit.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_head.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_row.dart';
import 'package:office_tracker/widgets/calendar/widgets/weekdays_row.dart';


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

  void onClick(DateTime date) {
    final parentContext = context;
    showDialog<String>(
      context: parentContext,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(formHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select day status:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: formHorizontalPadding, width: 2),
              TextButton(
                child: const Text('Present'),
                onPressed: () {
                  parentContext.read<PresenceHistoryCubit>().add(
                      date, PresenceEnum.present
                  );
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Absent'),
                onPressed: () {
                  parentContext.read<PresenceHistoryCubit>().add(
                      date, PresenceEnum.absent
                  );
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Day Off'),
                onPressed: () {
                  parentContext.read<PresenceHistoryCubit>().add(
                      date, PresenceEnum.dayOff
                  );
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Reset'),
                onPressed: () {
                  parentContext.read<PresenceHistoryCubit>().remove(date);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');
    final presenceHistory = context.watch<PresenceHistoryCubit>().state;
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
              onClick: onClick,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
              onClick: onClick,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 2),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
              onClick: onClick,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 3),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
              onClick: onClick,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 4),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
              onClick: onClick,
            ),
            CalendarRow(
              date: firstDayCalendar.add(weekDuration * 5),
              weekdaysOff: weekdaysOff,
              presenceHistory: presenceHistory,
              onClick: onClick,
            ),
          ],
        ),
      ),
    );
  }


}
