import 'package:flutter/material.dart';
import 'package:office_tracker/screens/main_app.dart';
import 'package:office_tracker/services/location_service.dart';
import 'package:office_tracker/utils/logging_util.dart';

void main() {
  LoggingUtil.configure();
  runApp(const MainApp());
}


