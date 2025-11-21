

String getWeekdayLabel(int weekday) {
  switch(weekday) {
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
    weekday,
    DateTime,
    'Invalid weekday index',
    'Index $weekday is invalid'
  );
}

String getMonthLabel(int month) {
  switch(month) {
    case DateTime.january:
      return 'January';
    case DateTime.february:
      return 'February';
    case DateTime.march:
      return 'March';
    case DateTime.april:
      return 'April';
    case DateTime.may:
      return 'May';
    case DateTime.june:
      return 'June';
    case DateTime.july:
      return 'July';
    case DateTime.august:
      return 'August';
    case DateTime.september:
      return 'September';
    case DateTime.october:
      return 'October';
    case DateTime.november:
      return 'November';
    case DateTime.december:
      return 'December';
  }
  throw RangeError.index(
      month,
      DateTime,
      'Invalid month index',
      'Index $month is invalid'
  );
}

String getReportSizeLabel(int size) {
  switch(size) {
    case 1:
      return '1 Month';
    default:
      return '$size Months';
  }
}