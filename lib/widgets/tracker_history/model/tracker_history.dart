import 'package:office_tracker/widgets/tracker_history/model/month_history.dart';

class TrackerHistory {
  final Map<int, MonthHistory> _history = {};

  bool isPresent(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    return _history.containsKey(year)
        && _history[year]!.isPresent(month, day);
  }

  void add(DateTime date) {
    final year = date.year;

    if (!_history.containsKey(year)) {
      _history[year] = MonthHistory();
    }

    _history[year]!.add(date);
  }

  void remove(DateTime date) {
    final year = date.month;

    if (_history.containsKey(year)) {
      _history[year]!.remove(date);
      if (_history[year]!.size() == 0) {
        _history.remove(year);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    _history.forEach((key, value) => json['$key'] = value.toJson());
    return json;
  }

  static TrackerHistory fromJson(Map<String, dynamic> json) {
    final trackerHistory = TrackerHistory();
    json.forEach((key, value) {
      final month = int.parse(key);
      trackerHistory._history[month] = MonthHistory.fromJson(value);
    });
    return trackerHistory;
  }
}
