import 'package:flutter/material.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';

typedef OnClickCallback = void Function(DateTime date);
class CalendarTile extends StatelessWidget {
  final DateTime date;
  final PresenceEnum presenceStatus;
  final bool isToday;
  final OnClickCallback? onClick;

  const CalendarTile({
    super.key,
    required this.date,
    required this.presenceStatus,
    this.isToday = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: () {
            if (onClick !=null) {
              onClick!(date);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: getPresenceColor(presenceStatus),
              borderRadius: BorderRadiusGeometry.all(Radius.circular(4.0)),
              border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: getBorderColor(presenceStatus),
                  )
              )
            ),
            child: Column(
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: (isToday) ? 12 : 10,
                    fontWeight: FontWeight.bold,
                    fontStyle: (isToday) ? FontStyle.italic : null,
                    decoration: (isToday) ? TextDecoration.underline : null,
                    color: (isToday) ? Colors.black : Colors.black87,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
