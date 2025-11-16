import 'package:flutter/material.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';

class CalendarTile extends StatelessWidget {
  final String text;
  final PresenceEnum presenceStatus;

  const CalendarTile({
    super.key,
    required this.text,
    required this.presenceStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: 200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: getPresenceColor(presenceStatus),
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
              border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: getBorderColor(presenceStatus),
                  )
              )
            ),
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
