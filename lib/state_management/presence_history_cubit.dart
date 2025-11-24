import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';

class PresenceHistoryCubit extends Cubit<TrackerHistory<PresenceEnum>> {
  static final _log = LoggingUtil('PresenceHistoryCubit');
  PresenceHistoryCubit() : super(TrackerHistory()) {
    _log.debug('Calling constructor');
    Future.delayed(Duration.zero, () async {
      _log.info('Loading presence history from shared preferences');
      final service = await PresenceHistoryService.instance;
      final obj = service.get();
      _log.debug('Loaded  presence history: $obj');
      emit(obj);
    });
  }

  void add(DateTime date, PresenceEnum status) {
    _log.info('Adding to presence history: $date');
    state.add(date, status);
    _save();
    emit(state);
  }

  void remove(DateTime date) {
    _log.info('Removing to presence history: $date');
    state.remove(date);
    _save();
    emit(state);
  }

  void _save() {
    Future.delayed(oneSecondDuration, () async {
      _log.debug('Saving presence history in shared preference');
      final service = await PresenceHistoryService.instance;
      service.save();
    });
  }
}