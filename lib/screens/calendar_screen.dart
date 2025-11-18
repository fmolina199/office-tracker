import 'package:flutter/material.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/widgets/calendar/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_head.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_row.dart';
import 'package:office_tracker/widgets/calendar/widgets/weekdays_row.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';


class CalendarScreen extends StatefulWidget {
  final Settings settings;
  final TrackerHistory<DateTime> presenceHistory;
  final TrackerHistory<DateTime>? holidayHistory;


  const CalendarScreen({
    super.key,
    required this.settings,
    required this.presenceHistory,
    this.holidayHistory,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
  DateTime _firstDayCalendar = getCurrentMonthDate();

  void setNewSelectedMonth(DateTime date) {
    setState(() {
      _selectedMonth = date;
      _firstDayCalendar = getFirstDayInCalendar(
          date,
          widget.settings.firstWeekday
      );
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
              onClickRightArrow:  addOneMonth,
            ),
            Row(
              children: [
                Expanded(child: Container(height: formHorizontalPadding)),
              ],
            ),
            WeekdaysRow(firstWeekday: widget.settings.firstWeekday),
            CalendarRow(
              date: _firstDayCalendar,
              presenceHistory: widget.presenceHistory,
            ),
            CalendarRow(
                date: _firstDayCalendar.add(weekDuration),
                presenceHistory: widget.presenceHistory,
            ),
            CalendarRow(
                date: _firstDayCalendar.add(weekDuration * 2),
                presenceHistory: widget.presenceHistory,
            ),
            CalendarRow(
                date: _firstDayCalendar.add(weekDuration * 3),
                presenceHistory: widget.presenceHistory,
            ),
            CalendarRow(
                date: _firstDayCalendar.add(weekDuration * 4),
                presenceHistory: widget.presenceHistory,
            ),
            CalendarRow(
                date: _firstDayCalendar.add(weekDuration * 5),
                presenceHistory: widget.presenceHistory,
            ),
          ],
        ),
      ),
    );
  }


}
