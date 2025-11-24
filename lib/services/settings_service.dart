import 'dart:convert';

import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final _log = LoggingUtil('SettingsService');
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  /// Class Implementation
  Settings settings = Settings();
  Future<void> _init() async {
    final settingsStr = await prefs.getString('settings') ?? '';
    if (settingsStr.isNotEmpty) {
      settings = Settings.fromJson(jsonDecode(settingsStr));
      _log.debug('Loaded settings: $settings');
    }
  }

  Settings get() => settings;

  Future<void> save(Settings settings) async {
    this.settings = settings;
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