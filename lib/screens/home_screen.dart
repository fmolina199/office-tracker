import 'package:flutter/material.dart';
import 'package:office_tracker/screens/calendar_screen.dart';
import 'package:office_tracker/screens/report_screen.dart';
import 'package:office_tracker/screens/settings_screen.dart';
import 'package:office_tracker/utils/logging_util.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _log = LoggingUtil('_HomeScreenState');

  final List<Widget> _widgets = <Widget>[
    CalendarScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    _log.debug('Calling build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_component_rounded),
              label: 'Settings',
          ),
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      )
    );
  }
}