import 'package:intl/intl.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';

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

  T? get(DateTime date) {
    return _history[date.day];
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
      } else if (T == PresenceEnum) {
        dayHistory._history[day] = getPresenceEnumFromString(
            value as String) as T;
      } else {
        dayHistory._history[day] = value as T;
      }
    });
    return dayHistory;
  }
}
