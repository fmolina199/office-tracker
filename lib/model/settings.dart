import 'package:office_tracker/services/location_service.dart';

class Settings {
  static const defaultReportSize = 3;
  static const defaultStartMonth = DateTime.january;
  static const defaultFirstWeekday = DateTime.sunday;
  static const defaultRequiredAttendance = 50;
  static const defaultWeekdaysOff = [DateTime.saturday, DateTime.sunday];
  static const defaultDistanceMeters = 50.0;

  // Report Settings
  final int reportMonthSize;
  final int reportStartMonth;
  final int firstWeekday;
  final int requiredAttendance;
  final List<int> weekdaysOff;
  // GPS Tracking Settings
  final bool foregroundTaskEnabled;
  final double distanceMeters;
  final GeoPosition? position;

  Settings({
    this.reportMonthSize = defaultReportSize,
    this.reportStartMonth = defaultStartMonth,
    this.firstWeekday = defaultFirstWeekday,
    this.requiredAttendance = defaultRequiredAttendance,
    this.weekdaysOff = defaultWeekdaysOff,
    this.foregroundTaskEnabled = false,
    this.distanceMeters = defaultDistanceMeters,
    this.position,
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
      'distanceMeters': distanceMeters,
      'position': position?.toJson(),
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = json['reportMonthSize'] as int,
        reportStartMonth = json['reportStartMonth'] as int,
        firstWeekday = json['firstWeekday'] as int,
        requiredAttendance = json['requiredAttendance'] as int,
        weekdaysOff = json['weekdaysOff'].cast<int>(),
        foregroundTaskEnabled = json['foregroundTaskEnabled'] as bool,
        distanceMeters = (json['distanceMeters'] ?? defaultDistanceMeters) as double,
        position = json['position'] == null
            ? null
            : GeoPosition.fromJson(json['position']);

  Settings copyWith({
    int? reportMonthSize,
    int? reportStartMonth,
    int? firstWeekday,
    int? requiredAttendance,
    List<int>? weekdaysOff,
    bool? foregroundTaskEnabled,
    double? distanceMeters,
    GeoPosition? position,
  }) {
    return Settings(
      reportMonthSize: reportMonthSize ?? this.reportMonthSize,
      reportStartMonth: reportStartMonth ?? this.reportStartMonth,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      requiredAttendance: requiredAttendance ?? this.requiredAttendance,
      weekdaysOff: weekdaysOff ?? this.weekdaysOff,
      foregroundTaskEnabled: foregroundTaskEnabled ?? this.foregroundTaskEnabled,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    final positionText = position == null
        ? 'Position is NOT set'
        : 'Position is set';
    return 'Settings { '
        'reportMonthSize: $reportMonthSize, '
        'reportStartMonth: $reportStartMonth, '
        'firstWeekday: $firstWeekday, '
        'requiredAttendance: $requiredAttendance, '
        'weekdaysOff: $weekdaysOff, '
        'foregroundTaskEnabled: $foregroundTaskEnabled, '
        'distanceMeters: $distanceMeters, '
        'position: "$positionText" '
        '}';
  }
}