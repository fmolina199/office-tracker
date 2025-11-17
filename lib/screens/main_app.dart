import 'package:flutter/material.dart';
import 'package:office_tracker/constants/colors.dart';
import 'package:office_tracker/screens/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Office Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      ),
      home: const HomeScreen(),
    );
  }
}