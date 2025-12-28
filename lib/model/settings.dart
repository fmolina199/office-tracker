import 'package:office_tracker/services/location_service.dart';

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
  final bool foregroundTaskEnabled;
  //TODO create necessary class structure for those attributes
  final double distance = 50;
  final GeoPosition position = GeoPosition(
      latitude: 53.3885205, longitude: -6.2581135);

  Settings({
    this.reportMonthSize = defaultReportSize,
    this.reportStartMonth = defaultStartMonth,
    this.firstWeekday = defaultFirstWeekday,
    this.requiredAttendance = defaultRequiredAttendance,
    this.weekdaysOff = defaultWeekdaysOff,
    this.foregroundTaskEnabled = false,
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
      'foregroundTaskEnabled': foregroundTaskEnabled,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = json['reportMonthSize'] as int,
        reportStartMonth = json['reportStartMonth'] as int,
        firstWeekday = json['firstWeekday'] as int,
        requiredAttendance = json['requiredAttendance'] as int,
        weekdaysOff = json['weekdaysOff'].cast<int>(),
        foregroundTaskEnabled = json['foregroundTaskEnabled'] as bool;

  Settings copyWith({
    int? reportMonthSize,
    int? reportStartMonth,
    int? firstWeekday,
    int? requiredAttendance,
    List<int>? weekdaysOff,
    bool? foregroundTaskEnabled,
  }) {
    return Settings(
      reportMonthSize: reportMonthSize ?? this.reportMonthSize,
      reportStartMonth: reportStartMonth ?? this.reportStartMonth,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      requiredAttendance: requiredAttendance ?? this.requiredAttendance,
      weekdaysOff: weekdaysOff ?? this.weekdaysOff,
      foregroundTaskEnabled: foregroundTaskEnabled ?? this.foregroundTaskEnabled,
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
        'foregroundTaskEnabled: $foregroundTaskEnabled '
        '}';
  }
}