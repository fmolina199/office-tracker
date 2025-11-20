import 'dart:convert';

import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final _log = LoggingUtil('SettingsService');

  /// Class Implementation
  Settings settings = Settings();
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsStr = prefs.getString('settings') ?? '';
    if (settingsStr.isNotEmpty) {
      settings = Settings.fromJson(jsonDecode(settingsStr));
    }
  }

  Settings get() => settings;

  void save(Settings settings) async {
    this.settings = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', jsonEncode(this.settings.toJson()));
  }

  /// Singleton Configuration
  SettingsService._privateConstructor();

  static SettingsService? _instance;

  static Future<SettingsService> get instance async {
    if (_instance == null) {
      SettingsService._log.debug('Starting SettingsService');
      _instance = SettingsService._privateConstructor();
      await _instance?._init();
    }
    return _instance!;
  }
}