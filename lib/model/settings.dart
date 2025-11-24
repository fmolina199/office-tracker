class Settings {
  static const defaultReportSize = 3;
  static const defaultStartMonth = DateTime.january;
  static const defaultFirstWeekday = DateTime.sunday;
  static const defaultRequiredAttendance = 50;
  static const defaultWeekdaysOff = [DateTime.saturday, DateTime.sunday];

  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekday;
  final int requiredAttendance;
  final List<int> weekdaysOff;
  final bool backgroundTaskEnabled;

  Settings({
    this.reportMonthSize = defaultReportSize,
    this.reportStartMonth = defaultStartMonth,
    this.firstWeekday = defaultFirstWeekday,
    this.requiredAttendance = defaultRequiredAttendance,
    this.weekdaysOff = defaultWeekdaysOff,
    this.backgroundTaskEnabled = false,
  }) : assert(1 <= reportMonthSize && reportMonthSize <= DateTime.monthsPerYear),
        assert(1 <= reportStartMonth && reportStartMonth <= DateTime.monthsPerYear),
        assert(0 <= requiredAttendance && requiredAttendance <= 100),
        assert(1 <= firstWeekday && firstWeekday <= DateTime.daysPerWeek);

  Map<String, dynamic> toJson() {
    return {
      'reportMonthSize': reportMonthSize,
      'reportStartMonth': reportStartMonth,
      'firstWeekday': firstWeekday,
      'requiredAttendance': requiredAttendance,
      'weekdaysOff': weekdaysOff,
      'backgroundTaskEnabled': backgroundTaskEnabled,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = json['reportMonthSize'] as int,
        reportStartMonth = json['reportStartMonth'] as int,
        firstWeekday = json['firstWeekday'] as int,
        requiredAttendance = json['requiredAttendance'] as int,
        weekdaysOff = json['weekdaysOff'].cast<int>(),
        backgroundTaskEnabled = json['backgroundTaskEnabled'] as bool;

  Settings copyWith({
    int? reportMonthSize,
    int? reportStartMonth,
    int? firstWeekday,
    int? requiredAttendance,
    List<int>? weekdaysOff,
    bool? backgroundTaskEnabled,
  }) {
    return Settings(
      reportMonthSize: reportMonthSize ?? this.reportMonthSize,
      reportStartMonth: reportStartMonth ?? this.reportStartMonth,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      requiredAttendance: requiredAttendance ?? this.requiredAttendance,
      weekdaysOff: weekdaysOff ?? this.weekdaysOff,
      backgroundTaskEnabled: backgroundTaskEnabled ?? this.backgroundTaskEnabled,
    );
  }

  @override
  String toString() {
    return 'Settings { '
        'reportMonthSize: $reportMonthSize, '
        'reportStartMonth: $reportStartMonth, '
        'firstWeekday: $firstWeekday, '
        'requiredAttendance: $requiredAttendance '
        'weekdaysOff: $weekdaysOff '
        'backgroundTaskEnabled: $backgroundTaskEnabled '
        '}';
  }
}