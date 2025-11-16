import 'package:flutter/material.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/calendar/widgets/calendar_tile.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: formHorizontalPadding),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CalendarTile(text: '1', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '2', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '3', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '4', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '5', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '6', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '7', presenceStatus: PresenceEnum.present),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalendarTile(text: '8', presenceStatus: PresenceEnum.dayOff),
                CalendarTile(text: '9', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '10', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '11', presenceStatus: PresenceEnum.dayOff),
                CalendarTile(text: '12', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '13', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '14', presenceStatus: PresenceEnum.present),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalendarTile(text: '15', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '16', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '17', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '18', presenceStatus: PresenceEnum.dayOff),
                CalendarTile(text: '19', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '20', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '21', presenceStatus: PresenceEnum.notPresent),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalendarTile(text: '22', presenceStatus: PresenceEnum.dayOff),
                CalendarTile(text: '23', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '24', presenceStatus: PresenceEnum.present),
                CalendarTile(text: '25', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '26', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '27', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '28', presenceStatus: PresenceEnum.notPresent),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalendarTile(text: '29', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '30', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '31', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '1', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '2', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '3', presenceStatus: PresenceEnum.notPresent),
                CalendarTile(text: '4', presenceStatus: PresenceEnum.notPresent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
