import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/constants/colors.dart';
import 'package:office_tracker/constants/menus.dart';
import 'package:office_tracker/constants/sizes.dart';
import 'package:office_tracker/handlers/location_handler.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/services/foreground_task_service.dart';
import 'package:office_tracker/services/location_service.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/utils/label_utils.dart';
import 'package:office_tracker/utils/logging_util.dart';
import 'package:office_tracker/utils/platform_utils.dart';
import 'package:office_tracker/widgets/forms/inputs/labeled_menu.dart';

final _sPortName = 'office_tracker/cancel_port';
Future<void> isolateMain(RootIsolateToken rootIsolateToken) async {
  final log = LoggingUtil('_isolateMain');
  log.info('Start workerManager task');
  BackgroundIsolateBinaryMessenger
      .ensureInitialized(rootIsolateToken);

  final ReceivePort receivePort = ReceivePort();
  final SendPort sendPort = receivePort.sendPort;

  log.info('Register send port');
  IsolateNameServer.removePortNameMapping(_sPortName);
  if (IsolateNameServer.registerPortWithName(sendPort, _sPortName)) {
    bool runForever = true;
    final streamSubscription = receivePort.listen((data) {
      runForever = data as bool;
    });

    log.info('Run forever...');
    while (runForever) {
      sleep(delayLocationDuration);
      await LocationHandler.process(DateTime.now());
    }
    log.info('Closing stream');
    streamSubscription.cancel();
  }
  log.info('Closing receive port');
  receivePort.close();
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final _log = LoggingUtil('SettingsScreen');

  int? requiredAttendance;
  double? distanceMeters;
  bool isForegroundServiceRunning = false;

  Future<void> _stopForegroundService(Settings settings) async {
    _log.info("Stopping foreground service");
    if (PlatformUtils.isMobile) {
      final foregroundService = await ForegroundTaskService.instance;
      await foregroundService.stopService();
    } else {
      final SendPort? sendPort = IsolateNameServer
          .lookupPortByName(_sPortName);
      sendPort?.send(false);
    }

    // Update screen
    if (context.mounted) {
      context.read<SettingsCubit>().set(
          settings.copyWith(
            foregroundTaskEnabled: false,
          )
      );
    }
  }

  Future<void> _startForegroundService(Settings settings) async {
    _log.info("Starting foreground service");

    // Make sure location permissions are granted
    await LocationService.instance;

    // Start Foreground service
    if (PlatformUtils.isMobile) {
      final foregroundService = await ForegroundTaskService.instance;
      await foregroundService.startService();
    } else {
      final rootIsolateToken = RootIsolateToken.instance!;
      Isolate.spawn(isolateMain, rootIsolateToken);
    }

    // Update screen
    if (context.mounted) {
      context.read<SettingsCubit>().set(
          settings.copyWith(
            foregroundTaskEnabled: true,
          )
      );
    }
  }

  void _updateForegroundServiceStatus() {
    if (PlatformUtils.isMobile) {
      Future.delayed(Duration.zero, () async {
        final isRunning = await FlutterForegroundTask.isRunningService;
        setState(() {
          isForegroundServiceRunning = isRunning;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateForegroundServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');

    final settings =  context.watch<SettingsCubit>().state;
    _log.debug('Settings: $settings');

    requiredAttendance ??= settings.requiredAttendance;
    distanceMeters ??= settings.distanceMeters;
    final int reportSize = settings.reportMonthSize;
    final int reportStartingMonth = settings.reportStartMonth;
    final int calendarFirstWeekday = settings.firstWeekday;
    final List<int> weekdaysOff = settings.weekdaysOff;
    final GeoPosition? position = settings.position;

    final startStoButton = (isForegroundServiceRunning
          || settings.foregroundTaskEnabled)
        ? ElevatedButton(
          onPressed: () async {
            await _stopForegroundService(settings);
          },
          child: Text('Stop GPS Tracking'),
        )
        : ElevatedButton(
          onPressed: () async {
           await _startForegroundService(settings);
          },
          child: Text('Start GPS Tracking'),
        );

    final currentLocationButton = (isForegroundServiceRunning
          || settings.foregroundTaskEnabled)
      ? Container()
      : ElevatedButton(
        onPressed: () async {
          final locationService = await LocationService.instance;
          sleep(halfSecondDuration);
          final position = await locationService.getLocation();
          if (context.mounted) {
            context.read<SettingsCubit>().set(
              settings.copyWith(
                position: position,
              )
            );
          }
        },
        child: Text('Set to Current Location')
      );

    return SingleChildScrollView(
      child: ConstrainedBox(
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
                  label: 'Attendance',
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
              Container(height: 2, color: mainColor.shade100),
              Container(height: 10),
              LabeledMenu(
                text: 'Distance (${distanceMeters?.toInt()}m):',
                child: Slider(
                  value: distanceMeters!,
                  max: 1000,
                  min: 50,
                  label: 'Distance',
                  onChanged: (newValue) {
                    setState(() {
                      distanceMeters = newValue.roundToDouble();
                    });
                  },
                  onChangeEnd: (newValue) => context.read<SettingsCubit>().set(
                      settings.copyWith(
                          distanceMeters: newValue.roundToDouble()
                      )
                  ),
                ),
              ),
              LabeledMenu(
                text: 'Latitude:',
                child: Text('${position?.latitude ?? 'Not set'}'),
              ),
              LabeledMenu(
                text: 'Longitude:',
                child: Text('${position?.longitude ?? 'Not set'}'),
              ),
              startStoButton,
              currentLocationButton,
            ],
          ),
        ),
      ),
    );
  }
}
