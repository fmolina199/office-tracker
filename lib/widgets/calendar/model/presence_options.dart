import 'package:flutter/material.dart';
import 'package:office_tracker/constants/colors.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';

enum PresenceEnum {
  present,
  absent,
  dayOff,
}

PresenceEnum getPresenceEnumFromString(String str) {
  for (PresenceEnum element in PresenceEnum.values) {
    if (element.toString() == str) {
      return element;
    }
  }
  throw ArgumentError('$str is not a valid PresenceEnum');
}

PresenceEnum getPresenceStatus({
  required DateTime date,
  required List<int> weekdaysOff,
  required TrackerHistory<PresenceEnum> presenceHistory,
  TrackerHistory<DateTime>? holidayHistory,
}) {
  if (presenceHistory.isPresent(date)) {
    return presenceHistory.get(date)!;
  }

  if (weekdaysOff.contains(date.weekday)
      || DateTime.now().isBefore(date)
      || (holidayHistory != null
          && holidayHistory.isPresent(date))
  ) {
    return PresenceEnum.dayOff;
  }

  return PresenceEnum.absent;
}

Color getPresenceColor(PresenceEnum option) {
  switch (option) {
    case PresenceEnum.present:
      return mainColor.shade100;
    case PresenceEnum.absent:
      return Colors.redAccent.shade100;
    case PresenceEnum.dayOff:
      return Colors.white70;
  }
}

Color getBorderColor(PresenceEnum option) {
  switch (option) {
    case PresenceEnum.present:
      return mainColor;
    case PresenceEnum.absent:
      return Colors.redAccent;
    case PresenceEnum.dayOff:
      return Colors.black12;
  }
}