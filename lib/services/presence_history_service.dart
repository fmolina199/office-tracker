import 'dart:convert';

import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresenceHistoryService {
  static final _log = LoggingUtil('PresenceHistoryService');
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  /// Class Implementation
  TrackerHistory<PresenceEnum> presenceHistory = TrackerHistory();
  Future<void> _init() async {
    final presenceHistoryStr = await prefs.getString('presenceHistory') ?? '';
    if (presenceHistoryStr.isNotEmpty) {
      presenceHistory = TrackerHistory
          .fromJson<PresenceEnum>(
              jsonDecode(presenceHistoryStr));
    }
  }

  TrackerHistory<PresenceEnum> get() => presenceHistory;

  Future<void> save() async {
    await prefs.setString(
        'presenceHistory', jsonEncode(presenceHistory.toJson()));
  }

  /// Singleton Configuration
  PresenceHistoryService._privateConstructor();

  static PresenceHistoryService? _instance;

  static Future<PresenceHistoryService> get instance async {
    if (_instance == null) {
      PresenceHistoryService._log.debug('Starting PresenceHistoryService');
      _instance = PresenceHistoryService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }
}