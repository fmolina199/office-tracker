class Settings {
  static const defaultWeekdaysOff = [DateTime.saturday, DateTime.sunday];
  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekday;
  final List<int> weekdaysOff;

  Settings({
    this.reportMonthSize = 3,
    this.reportStartMonth = 1,
    this.firstWeekday = DateTime.sunday,
    this.weekdaysOff = defaultWeekdaysOff,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportMonthSize': reportMonthSize,
      'reportStartMonth': reportStartMonth,
      'firstWeekday': firstWeekday,
      'weekdaysOff': weekdaysOff,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = json['reportMonthSize'] as int,
        reportStartMonth = json['reportStartMonth'] as int,
        firstWeekday = json['firstWeekday'] as int,
        weekdaysOff = json['weekdaysOff'] as List<int>;
}