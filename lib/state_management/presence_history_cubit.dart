import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/services/presence_history_service.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';

class PresenceHistoryCubit extends Cubit<PresenceHistoryService?> {
  static final _log = LoggingUtil('PresenceHistoryCubit');

  PresenceHistoryCubit() : super(null) {
    _log.debug('Calling constructor');
    Future.delayed(Duration.zero, () async {
      _log.debug('Loading singleton');
      final phService = await PresenceHistoryService.instance;
      phService.setEmitFunction(emit);
      emit(phService);
    });
  }

  void add(DateTime date, PresenceEnum status) async {
    _log.info('Adding to presence history: $date');
    final service = await PresenceHistoryService.instance;
    await service.add(date, status);
    emit(service);
  }

  void remove(DateTime date) async {
    _log.info('Removing to presence history: $date');
    final service = await PresenceHistoryService.instance;
    await service.remove(date);
    emit(service);
  }
}