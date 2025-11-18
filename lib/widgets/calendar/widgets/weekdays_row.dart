import 'package:flutter/material.dart';
import 'package:office_tracker/utils/label_utils.dart';
import 'package:office_tracker/widgets/calendar/widgets/weekday_label.dart';

class WeekdaysRow extends StatelessWidget {
  final int firstWeekday;

  const WeekdaysRow({
    super.key,
    required this.firstWeekday,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    var weekday = firstWeekday;
    for (var i = 0; i < DateTime.daysPerWeek; i++) {
      widgets.add(WeekdayLabel(text: getWeekdayLabel(weekday)));
      weekday = (weekday % DateTime.daysPerWeek) + 1;
    }
    return Row(
      children: widgets,
    );
  }
}
