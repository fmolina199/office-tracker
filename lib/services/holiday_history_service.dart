import 'dart:convert';

import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HolidayHistoryService {
  static final _log = LoggingUtil('HolidayHistoryService');

  /// Class Implementation
  TrackerHistory<DateTime> holidayHistory = TrackerHistory();
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final holidayHistoryStr = prefs.getString('holidayHistory') ?? '';
    if (holidayHistoryStr.isNotEmpty) {
      holidayHistory = TrackerHistory.fromJson<DateTime>(jsonDecode(holidayHistoryStr));
    }
  }

  TrackerHistory<DateTime> get() => holidayHistory;

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('holidayHistory', jsonEncode(holidayHistory.toJson()));
  }

  /// Singleton Configuration
  HolidayHistoryService._privateConstructor();

  static HolidayHistoryService? _instance;

  static Future<HolidayHistoryService> get instance async {
    if (_instance == null) {
      HolidayHistoryService._log.debug('Starting HolidayHistoryService');
      _instance = HolidayHistoryService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }
}