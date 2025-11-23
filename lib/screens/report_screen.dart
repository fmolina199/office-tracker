import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:office_tracker/model/report_result.dart';
import 'package:office_tracker/model/settings.dart';
import 'package:office_tracker/state_management/presence_history_cubit.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';
import 'package:office_tracker/widgets/calendar/constants/sizes.dart';
import 'package:office_tracker/widgets/calendar/model/presence_options.dart';
import 'package:office_tracker/widgets/tracker_history/model/tracker_history.dart';

class ReportScreen extends StatelessWidget {
  static const checkIcon = Icon(Icons.check, color: Colors.lightGreen);
  static const closeIcon = Icon(Icons.close, color: Colors.red);
  static final dateFormat = DateFormat('yyyy-MM-dd');

  const ReportScreen({super.key});

  DateTime getFirstDate({
    required int startingMonth,
    required int reportSize,
    required int index,
  }) {
    final today = DateTime.now();
    int year = today.year;
    int month = today.month;
    final modStartingMonth = (startingMonth-1) % reportSize;
    month = month
        - ((month-1-modStartingMonth) % reportSize)
        - index*reportSize;
    return DateTime(
      year,
      month,
      1,
      12,
    );
  }

  ReportResult getResult({
    required Settings settings,
    required DateTime reportDate,
    required TrackerHistory<PresenceEnum> presenceHistory,
    TrackerHistory<DateTime>? holidayHistory,
  }) {
    DateTime today = DateTime.now();
    today = DateTime(
      today.year,
      today.month,
      today.day+1,
    );
    final DateTime endReport = DateTime(
      reportDate.year,
      reportDate.month + settings.reportMonthSize,
      1,
    );
    int daysPresent = 0;
    int daysAbsent = 0;
    int daysOff = 0;
    while (reportDate.isBefore(endReport) && reportDate.isBefore(today)) {
      final status = getPresenceStatus(
        date: reportDate,
        weekdaysOff: settings.weekdaysOff,
        presenceHistory: presenceHistory,
        holidayHistory: holidayHistory,
      );
      switch(status) {
        case PresenceEnum.present:
          daysPresent++;
        case PresenceEnum.absent:
          daysAbsent++;
        case PresenceEnum.dayOff:
          daysOff++;
      }
      reportDate = reportDate.add(oneDayDuration);
    }
    return ReportResult(
      daysPresent: daysPresent,
      daysAbsent: daysAbsent,
      daysOff: daysOff,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context)
        .copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: 12,
        itemBuilder: (context, index) {
          final settings = context.watch<SettingsCubit>().state;
          final presenceHistory = context.watch<PresenceHistoryCubit>().state;
          final reportDate = getFirstDate(
            index: index,
            reportSize: settings.reportMonthSize,
            startingMonth: settings.reportStartMonth,
          );
          final result = getResult(
            settings: settings,
            reportDate: reportDate,
            presenceHistory: presenceHistory,
            holidayHistory: TrackerHistory(),
          );
          final percentage = result.getPercentage();
          final isAboveRequired = percentage >= settings.requiredAttendance;
          return ListTile(
            leading: (isAboveRequired) ? checkIcon : closeIcon,
            title: Text('${percentage.toStringAsFixed(2)}% presence'
                ' from ${dateFormat.format(reportDate)}'),
            subtitle: Text('Present: ${result.daysPresent};'
                ' Absent: ${result.daysAbsent};'
                ' Off: ${result.daysOff};'),
          );
        },
      ),
    );
  }
}
