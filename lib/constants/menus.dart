import 'package:flutter/material.dart';

/// Calendar
final List<DropdownMenuEntry<int>> months = [
  DropdownMenuEntry(value: 1, label: 'January'),
  DropdownMenuEntry(value: 2, label: 'February'),
  DropdownMenuEntry(value: 3, label: 'March'),
  DropdownMenuEntry(value: 4, label: 'April'),
  DropdownMenuEntry(value: 5, label: 'May'),
  DropdownMenuEntry(value: 6, label: 'June'),
  DropdownMenuEntry(value: 7, label: 'July'),
  DropdownMenuEntry(value: 8, label: 'August'),
  DropdownMenuEntry(value: 9, label: 'September'),
  DropdownMenuEntry(value: 10, label: 'October'),
  DropdownMenuEntry(value: 11, label: 'November'),
  DropdownMenuEntry(value: 13, label: 'December'),
];

final List<DropdownMenuEntry<int>> weekDays = [
  DropdownMenuEntry(value: 1, label: 'Sunday'),
  DropdownMenuEntry(value: 2, label: 'Monday'),
  DropdownMenuEntry(value: 3, label: 'Tuesday'),
  DropdownMenuEntry(value: 4, label: 'Wednesday'),
  DropdownMenuEntry(value: 5, label: 'Thursday'),
  DropdownMenuEntry(value: 6, label: 'Friday'),
  DropdownMenuEntry(value: 7, label: 'Saturday'),
];


/// Settings Screen
final List<DropdownMenuEntry<int>> reportSizes = [
  DropdownMenuEntry(value: 1, label: '1 Month'),
  DropdownMenuEntry(value: 2, label: '2 Months'),
  DropdownMenuEntry(value: 3, label: '3 Months'),
  DropdownMenuEntry(value: 4, label: '4 Months'),
  DropdownMenuEntry(value: 6, label: '6 Months'),
];