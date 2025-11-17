import 'package:flutter/material.dart';
import 'package:office_tracker/widgets/calendar/widgets/week_day_label.dart';

class WeekDaysRow extends StatelessWidget {
  final int firstWeekDay;

  const WeekDaysRow({
    super.key,
    required this.firstWeekDay,
  });

  static String getLabel(int weekDay) {
    switch(weekDay) {
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.sunday:
        return 'Sunday';
    }
    throw RangeError.index(
        weekDay,
        DateTime,
        'Invalid weekday index',
        'Index $weekDay is invalid'
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    var weekDay = firstWeekDay;
    for (var i = 0; i < 7; i++) {
      widgets.add(WeekDayLabel(text: getLabel(weekDay)));
      weekDay = (weekDay % DateTime.daysPerWeek) + 1;
    }
    return Row(
      children: widgets,
    );
  }
}
