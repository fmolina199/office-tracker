import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/services/settings_service.dart';
import 'package:office_tracker/utils/logging_util.dart';

class SettingsCubit extends Cubit<Settings> {
  static final _log = LoggingUtil('SettingsCubit');
  SettingsCubit() : super(Settings()) {
    _log.debug('Calling constructor');
    Future.delayed(halfSecondDuration, () async {
      _log.debug('Loading settings from shared preferences');
      final service = await SettingsService.instance;
      final obj = service.get();
      _log.debug('Loaded settings: $obj');
      emit(obj);
    });
  }

  void set(final Settings settings) {
    Future.delayed(oneSecondDuration, () async {
      _log.debug('Saving settings in shared preference: $settings');
      final savedObj = await SettingsService.instance;
      await savedObj.save(settings);
    });
    emit(settings);
  }
}