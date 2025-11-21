class Settings {
  static const defaultWeekdaysOff = [DateTime.saturday, DateTime.sunday];
  static const defaultReportSize = 3;
  static const defaultStartMonth = DateTime.january;
  static const defaultFirstWeekday = DateTime.sunday;
  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekday;
  final List<int> weekdaysOff;

  Settings({
    this.reportMonthSize = defaultReportSize,
    this.reportStartMonth = defaultStartMonth,
    this.firstWeekday = defaultFirstWeekday,
    this.weekdaysOff = defaultWeekdaysOff,
  }) : assert(1 <= reportMonthSize && reportMonthSize <= 12),
        assert(1 <= reportStartMonth && reportStartMonth <= 12),
        assert(1 <= firstWeekday && firstWeekday <= 7);

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
        weekdaysOff = json['weekdaysOff'].cast<int>();

  Settings copyWith({
    int? reportMonthSize,
    int? reportStartMonth,
    int? firstWeekday,
    List<int>? weekdaysOff,
  }) {
    return Settings(
      reportMonthSize: reportMonthSize ?? this.reportMonthSize,
      reportStartMonth: reportStartMonth ?? this.reportStartMonth,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      weekdaysOff: weekdaysOff ?? this.weekdaysOff,
    );
  }

  @override
  String toString() {
    return 'Settings { '
        'reportMonthSize: $reportMonthSize, '
        'reportStartMonth: $reportStartMonth, '
        'firstWeekday: $firstWeekday, '
        'weekdaysOff: $weekdaysOff '
        '}';
  }
}