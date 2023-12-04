import 'package:get/get.dart';

import '../../../../presentation/alarm_clock/controllers/alarm_clock_controller.dart';

class AlarmClockControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmClockController>(
      () => AlarmClockController(),
    );
  }
}
