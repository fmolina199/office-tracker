class Settings {
  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekday;

  Settings({
    this.reportMonthSize = 3,
    this.reportStartMonth = 1,
    this.firstWeekday = DateTime.sunday,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportMonthSize': reportMonthSize,
      'reportStartMonth': reportStartMonth,
      'firstWeekday': firstWeekday,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = int.parse(json['reportMonthSize']),
        reportStartMonth = int.parse(json['reportStartMonth']),
        firstWeekday = int.parse(json['firstWeekday']);
}