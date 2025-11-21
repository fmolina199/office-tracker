import 'dart:math';
import 'package:office_tracker/widgets/tracker_history/model/month_history.dart';

class TrackerHistory<T> {
  final Map<int, MonthHistory> _history = {};

  TrackerHistory();

  bool isPresent(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    return _history.containsKey(year)
        && _history[year]!.isPresent(month, day);
  }

  void add(DateTime date, T data) {
    final year = date.year;

    if (!_history.containsKey(year)) {
      _history[year] = MonthHistory<T>();
    }

    _history[year]!.add(date, data);
  }

  void remove(DateTime date) {
    final year = date.year;
    if (_history.containsKey(year)) {
      _history[year]!.remove(date);
      if (_history[year]!.size() == 0) {
        _history.remove(year);
      }
    }
  }

  T? get(DateTime date) {
    return _history[date.year]?.get(date);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    _history.forEach((key, value) => json['$key'] = value.toJson());
    return json;
  }

  static TrackerHistory<T> fromJson<T>(Map<String, dynamic> json) {
    final trackerHistory = TrackerHistory<T>();
    json.forEach((key, value) {
      final month = int.parse(key);
      trackerHistory._history[month] = MonthHistory.fromJson<T>(value);
    });
    return trackerHistory;
  }

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => Random().nextInt(9999999);

  @override
  String toString() {
    return 'TrackerHistory { length: ${_history.length} }';
  }
}
