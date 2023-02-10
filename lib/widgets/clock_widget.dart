import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  String get currentTime {
    return DateFormat("HH:mm:ss").format(DateTime.now());
  }

  String get currentDate {
    return DateFormat("dd/MMMM/yyyy", "es_MX").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      return Center(
        child: Column(children: [
          Text(
            currentDate,
            style: const TextStyle(
                color: Color.fromARGB(255, 26, 4, 83),
                fontSize: 64,
                fontWeight: FontWeight.w400),
          ),
          const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          Text(
            currentTime,
            style: const TextStyle(
                color: Color.fromARGB(255, 26, 4, 83),
                fontSize: 96,
                fontWeight: FontWeight.w300),
          ),
          const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        ]),
      );
    });
  }
}
