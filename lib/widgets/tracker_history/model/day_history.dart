import 'package:intl/intl.dart';

class DayHistory<T> {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final Map<int, T> _history = {};

  bool isPresent(int day) {
    return _history.containsKey(day);
  }

  void add(DateTime date, T data) {
    _history[date.day] = data;
  }

  void remove(DateTime date) {
    _history.remove(date.day);
  }

  int size() {
    return _history.length;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> days = {};
    _history.forEach((key, value) {
      if (T == DateTime) {
        days['$key'] = _dateFormat.format(value as DateTime);
      } else {
        days['$key'] = '$value';
      }
    });
    return days;
  }

  static DayHistory fromJson<T>(Map<String, dynamic> days) {
    final dayHistory = DayHistory<T>();
    days.forEach((key, value) {
      final day = int.parse(key);
      if (T == DateTime) {
        dayHistory._history[day] = _dateFormat.parse(value) as T;
      } else {
        dayHistory._history[day] = value as T;
      }
    });
    return dayHistory;
  }
}
