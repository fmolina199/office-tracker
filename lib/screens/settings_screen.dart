import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/menus.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/services/geofance_service.dart';
import 'package:office_tracker/services/notification_service.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/label_utils.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/widgets/forms/inputs/labeled_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final _log = LoggingUtil('SettingsScreen');

  int? requiredAttendance;
  List<String> activeGeofence = [];
  String event = 'Unknown';

  Future<void> _updateRegisteredGeofence() async {
    final geofenceService = await GeofenceService.instance;
    final List<String> geofence = await geofenceService.getActiveGeofence();
    setState(() {
      activeGeofence = geofence;
    });
    _log.debug('Active geofence updated.');
  }

  @override
  void initState() {
    super.initState();
    _updateRegisteredGeofence();
  }

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');

    final settings =  context.watch<SettingsCubit>().state;
    _log.debug('Settings: $settings');

    requiredAttendance ??= settings.requiredAttendance;
    final int reportSize = settings.reportMonthSize;
    final int reportStartingMonth = settings.reportStartMonth;
    final int calendarFirstWeekday = settings.firstWeekday;
    final List<int> weekdaysOff = settings.weekdaysOff;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 600,
      ),
      child: Padding(
        padding: const EdgeInsets.all(formHorizontalPadding),
        child: Column(
          spacing: betweenItemsSpace,
          children: [
            LabeledMenu(
              text: 'Report Size:',
              child: DropdownSearch<int>(
                selectedItem: reportSize,
                items: (f, cs) => reportSizeList,
                itemAsString: (item) => getReportSizeLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    reportMonthSize: newValue ?? Settings.defaultReportSize
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'Starting Month:',
              child: DropdownSearch<int>(
                selectedItem: reportStartingMonth,
                items: (f, cs) => monthList,
                itemAsString: (item) => getMonthLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                   reportStartMonth: newValue ?? Settings.defaultStartMonth
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'First Weekday:',
              child: DropdownSearch<int>(
                selectedItem: calendarFirstWeekday,
                items: (f, cs) => weekdayList,
                itemAsString: (item) => getWeekdayLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    firstWeekday: newValue ?? Settings.defaultFirstWeekday
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'Weekdays Off:',
              child: DropdownSearch<int>.multiSelection(
                selectedItems: weekdaysOff,
                items: (f, cs) => weekdayList,
                itemAsString: (item) => getWeekdayLabel(item),
                onChanged: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    weekdaysOff: newValue
                  )
                ),
              ),
            ),
            LabeledMenu(
              text: 'Required Attendance ($requiredAttendance%):',
              child: Slider(
                value: requiredAttendance!.toDouble(),
                max: 100,
                min: 0,
                label: 'Label',
                onChanged: (newValue) {
                  setState(() {
                    requiredAttendance = newValue.toInt();
                  });
                },
                onChangeEnd: (newValue) => context.read<SettingsCubit>().set(
                  settings.copyWith(
                    requiredAttendance: newValue.toInt()
                  )
                ),
              ),
            ),
            Text('Active Geofence: $activeGeofence'),
            ElevatedButton(
              onPressed: () async {
                final geofenceService = await GeofenceService.instance;
                await geofenceService.createGeofence(
                    latitude: 53.3885107,
                    longitude: -6.2581675,
                );
                await _updateRegisteredGeofence();
                final notificationService = await NotificationService.instance;
                await notificationService.sendNotification(
                    "Starting bg location", "Location service");
              },
              child: Text('Start Background Tracking'),
            ),
            ElevatedButton(
              onPressed: () async {
                final geofenceService = await GeofenceService.instance;
                await geofenceService.deleteGeofence();
                await _updateRegisteredGeofence();
              },
              child: Text('Stop Background Tracking'),
            ),
            Text('Received event: $event'),
          ],
        ),
      ),
    );
  }
}
