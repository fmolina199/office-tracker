import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/services/settings_service.dart';
import 'package:office_tracker/utils/logging_util.dart';

class SettingsCubit extends Cubit<Settings> {
  static final _log = LoggingUtil('SettingsCubit');
  SettingsCubit() : super(Settings()) {
    _log.debug('Calling constructor');
    Future.delayed(oneSecondDuration, () async {
      _log.debug('Loading settings from shared preferences');
      final savedSettings = await SettingsService.instance;
      _log.debug('Loaded settings $savedSettings');
      emit(savedSettings.get());
    });
  }

  void set(final Settings settings) {
    Future.delayed(oneSecondDuration, () async {
      _log.debug('Saving settings in shared preference: $settings');
      final savedSettings = await SettingsService.instance;
      await savedSettings.save(settings);
    });
    emit(settings);
  }
}