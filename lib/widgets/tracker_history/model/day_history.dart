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

  // TODO HERE convert for a generic value so we can store different data
  List<String> toJson() {
    final List<String> days = [];
    for (var value in _history.values) {
      //TODO add day and also data
      if (T is DateTime) {
        days.add(_dateFormat.format(value as DateTime));
      } else {
        days.add('$value');
      }
    }
    return days;
  }

  static DayHistory fromJson<T>(List<String> days) {
    final dayHistory = DayHistory<T>();
    for (var day in days) {
      //TODO convert from day and data
      if (T is DateTime) {
        dayHistory.add(DateTime.now(), _dateFormat.parse(day) as T);
      } else {
        dayHistory.add(DateTime.now(), day as T);
      }
    }
    return dayHistory;
  }
}
