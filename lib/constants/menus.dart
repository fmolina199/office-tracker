import 'package:flutter/material.dart';

/// Calendar
final List<DropdownMenuEntry<int>> months = [
  DropdownMenuEntry(value: DateTime.january, label: 'January'),
  DropdownMenuEntry(value: DateTime.february, label: 'February'),
  DropdownMenuEntry(value: DateTime.march, label: 'March'),
  DropdownMenuEntry(value: DateTime.april, label: 'April'),
  DropdownMenuEntry(value: DateTime.may, label: 'May'),
  DropdownMenuEntry(value: DateTime.june, label: 'June'),
  DropdownMenuEntry(value: DateTime.july, label: 'July'),
  DropdownMenuEntry(value: DateTime.august, label: 'August'),
  DropdownMenuEntry(value: DateTime.september, label: 'September'),
  DropdownMenuEntry(value: DateTime.october, label: 'October'),
  DropdownMenuEntry(value: DateTime.november, label: 'November'),
  DropdownMenuEntry(value: DateTime.december, label: 'December'),
];

final List<DropdownMenuEntry<int>> weekDays = [
  DropdownMenuEntry(value: DateTime.sunday, label: 'Sunday'),
  DropdownMenuEntry(value: DateTime.monday, label: 'Monday'),
  DropdownMenuEntry(value: DateTime.tuesday, label: 'Tuesday'),
  DropdownMenuEntry(value: DateTime.wednesday, label: 'Wednesday'),
  DropdownMenuEntry(value: DateTime.thursday, label: 'Thursday'),
  DropdownMenuEntry(value: DateTime.friday, label: 'Friday'),
  DropdownMenuEntry(value: DateTime.saturday, label: 'Saturday'),
];


/// Settings Screen
final List<DropdownMenuEntry<int>> reportSizes = [
  DropdownMenuEntry(value: 1, label: '1 Month'),
  DropdownMenuEntry(value: 2, label: '2 Months'),
  DropdownMenuEntry(value: 3, label: '3 Months'),
  DropdownMenuEntry(value: 4, label: '4 Months'),
  DropdownMenuEntry(value: 6, label: '6 Months'),
];