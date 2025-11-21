import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_tracker/constants/colors.dart';
import 'package:office_tracker/screens/home_screen.dart';
import 'package:office_tracker/state_management/presence_history_cubit.dart';
import 'package:office_tracker/state_management/settings_cubit.dart';

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(
            create: (_) => SettingsCubit(),
          ),
          BlocProvider<PresenceHistoryCubit>(
            create: (_) => PresenceHistoryCubit(),
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}