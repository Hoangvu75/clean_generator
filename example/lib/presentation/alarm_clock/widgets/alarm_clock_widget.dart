import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/alarm_clock_controller.dart';

class AlarmClockWidget extends GetWidget<AlarmClockController> {
  const AlarmClockWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlarmClockWidget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AlarmClockWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
