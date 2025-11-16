import 'package:office_tracker/widgets/tracker_history/model/day_history.dart';

class MonthHistory<T> {
  final Map<int, DayHistory> _history = {};

  bool isPresent(int month, int day) {
    return _history.containsKey(month)
      && _history[month]!.isPresent(day);
  }

  void add(DateTime date, T data) {
    final month = date.month;

    if (!_history.containsKey(month)) {
      _history[month] = DayHistory<T>();
    }

    _history[month]!.add(date, data);
  }

  void remove(DateTime date) {
    final month = date.month;

    if (_history.containsKey(month)) {
      _history[month]!.remove(date);
      if (_history[month]!.size() == 0) {
        _history.remove(month);
      }
    }
  }

  int size() {
    return _history.length;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    _history.forEach((key, value) => json['$key'] = value.toJson());
    return json;
  }

  static MonthHistory fromJson(Map<String, dynamic> json) {
    final monthHistory = MonthHistory();
    json.forEach((key, value) {
      final month = int.parse(key);
      monthHistory._history[month] = DayHistory.fromJson(value);
    });
    return monthHistory;
  }
}
