import 'package:flutter/material.dart';
import 'package:office_tracker/widgets/calendar/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_tile.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';

class CalendarRow extends StatelessWidget {
  final DateTime date;
  final TrackerHistory<DateTime> presenceHistory;
  final TrackerHistory<DateTime>? holidayHistory;

  const CalendarRow({
    super.key,
    required this.date,
    required this.presenceHistory,
    this.holidayHistory,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    var countDate = date;
    for (var i=0; i<DateTime.daysPerWeek; i++) {
      widgets.add(CalendarTile(
          date: countDate,
          presenceStatus: getPresenceStatus(
              date: countDate,
              presenceHistory: presenceHistory,
              holidayHistory: holidayHistory)
      ));
      countDate = countDate.add(oneDayDuration);
    }

    return Expanded(
      child: Row(
        children: widgets,
      ),
    );
  }
}
