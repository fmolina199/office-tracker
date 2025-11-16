class Settings {
  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekDay;

  Settings({
    this.reportMonthSize = 3,
    this.reportStartMonth = 1,
    this.firstWeekDay = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportMonthSize': reportMonthSize,
      'reportStartMonth': reportStartMonth,
      'firstWeekDay': firstWeekDay,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = int.parse(json['reportMonthSize']),
        reportStartMonth = int.parse(json['reportStartMonth']),
        firstWeekDay = int.parse(json['firstWeekDay']);
}