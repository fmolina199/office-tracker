import 'package:flutter/material.dart';
import 'package:office_tracker/constants/colors.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';

enum PresenceEnum {
  present,
  notPresent,
  dayOff,
}

PresenceEnum getPresenceStatus({
  required DateTime date,
  required TrackerHistory presenceHistory,
  TrackerHistory? holidayHistory,
}) {
  if (presenceHistory.isPresent(date)) {
    return PresenceEnum.present;
  }

  if (date.weekday == DateTime.saturday
      || date.weekday == DateTime.sunday
      || DateTime.now().isBefore(date)
      || (holidayHistory != null
          && holidayHistory.isPresent(date))
  ) {
    return PresenceEnum.dayOff;
  }

  return PresenceEnum.notPresent;
}

Color getPresenceColor(PresenceEnum option) {
  switch (option) {
    case PresenceEnum.present:
      return mainColor.shade100;
    case PresenceEnum.notPresent:
      return Colors.redAccent.shade100;
    case PresenceEnum.dayOff:
      return Colors.white70;
  }
}

Color getBorderColor(PresenceEnum option) {
  switch (option) {
    case PresenceEnum.present:
      return mainColor;
    case PresenceEnum.notPresent:
      return Colors.redAccent;
    case PresenceEnum.dayOff:
      return Colors.black12;
  }
}