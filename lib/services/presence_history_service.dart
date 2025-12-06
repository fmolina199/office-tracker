import 'dart:convert';
import 'dart:math';

import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef EmitFunction = void Function(PresenceHistoryService state);
class PresenceHistoryService {
  static final _log = LoggingUtil('PresenceHistoryService');

  /// Class Implementation
  final random = Random();
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  TrackerHistory<PresenceEnum> _presenceHistory = TrackerHistory();
  EmitFunction? _emitFunction;

  void setEmitFunction(EmitFunction callback) {
    _emitFunction = callback;
  }

  Future<void> _init() async {
    final presenceHistoryStr = await prefs.getString('presenceHistory') ?? '';
    if (presenceHistoryStr.isNotEmpty) {
      _presenceHistory = TrackerHistory
          .fromJson<PresenceEnum>(
              jsonDecode(presenceHistoryStr));
    }
  }

  Future<void> add(DateTime date, PresenceEnum status) async {
    _presenceHistory.add(date, status);
    await save();
  }

  Future<void> remove(DateTime date) async {
    _presenceHistory.remove(date);
    await save();
  }

  PresenceEnum? get(DateTime date) {
    return _presenceHistory.get(date);
  }

  bool isPresent(DateTime date) {
    return _presenceHistory.isPresent(date);
  }

  Future<void> save() async {
    await prefs.setString(
        'presenceHistory', jsonEncode(_presenceHistory.toJson()));
  }

  Future<void> reloadFromFile() async {
    await _init();
    _emitFunction?.call(_instance!);
  }

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => random.nextInt(9999999);

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