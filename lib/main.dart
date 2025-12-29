import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:office_tracker/screens/main_app.dart';
import 'package:office_tracker/utils/logging_util.dart';

void main() async {
  LoggingUtil.configure();
  FlutterForegroundTask.initCommunicationPort();
  runApp(const MainApp());
}


