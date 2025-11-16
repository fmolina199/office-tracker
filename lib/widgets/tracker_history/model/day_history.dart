import 'package:intl/intl.dart';

class DayHistory {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final Map<int, DateTime> _history = {};

  bool isPresent(int day) {
    return _history.containsKey(day);
  }

  void add(DateTime date) {
    _history[date.day] = date;
  }

  void remove(DateTime date) {
    _history.remove(date.day);
  }

  int size() {
    return _history.length;
  }

  List<String> toJson() {
    final List<String> days = [];
    for (var value in _history.values) {
      days.add(_dateFormat.format(value));
    }
    return days;
  }

  static DayHistory fromJson(List<String> days) {
    final dayHistory = DayHistory();
    for (var day in days) {
      dayHistory.add(_dateFormat.parse(day));
    }
    return dayHistory;
  }
}
