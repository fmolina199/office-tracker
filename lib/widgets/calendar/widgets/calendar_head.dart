import 'package:flutter/material.dart';
import 'package:office_tracker/utils/label_utils.dart';


class CalendarHead extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onClickLeftArrow;
  final VoidCallback? onClickRightArrow;
  const CalendarHead({
    super.key,
    required this.date,
    this.onClickLeftArrow,
    this.onClickRightArrow,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
          ),
          onPressed: onClickLeftArrow,
        ),
        Expanded(
          child: Center(
            child: Text(
              '${getMonthLabel(date.month)} ${date.year}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            size: 20,
          ),
          onPressed: onClickRightArrow,
        ),
      ],
    );
  }
}
