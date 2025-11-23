class ReportResult {
  final int daysPresent;
  final int daysAbsent;
  final int daysOff;
  double? _percentage;

  ReportResult({
    this.daysPresent = 0,
    this.daysAbsent = 0,
    this.daysOff = 0,
  }) {
    _percentage = (daysPresent*100.0)/(daysAbsent+daysPresent);
  }

  double getPercentage() {
    return _percentage!;
  }
}