import 'dart:ui';

import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  static const checkIcon = Icon(Icons.check, color: Colors.lightGreen);
  static const closeIcon = Icon(Icons.close, color: Colors.red);

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
        itemCount: 100,
        itemBuilder: (context, index) {
          /// TODO fill with correct math
          return ListTile(
            leading: closeIcon,
            title: Text('Presence $index%'),
            subtitle: Text('Days present 32:, days absent: 2, holidays: 123'),
          );
        },
      ),
    );
  }
}
