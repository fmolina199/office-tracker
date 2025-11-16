class Settings {
  final int reportMonthSize;
  final int reportStartMonth;

  Settings({
    required this.reportMonthSize,
    required this.reportStartMonth,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportMonthSize': reportMonthSize,
      'reportStartMonth': reportStartMonth,
    };
  }

  Settings.fromJson(Map<String, dynamic> json)
      : reportMonthSize = int.parse(json['reportMonthSize']),
        reportStartMonth = int.parse(json['reportStartMonth']);
}