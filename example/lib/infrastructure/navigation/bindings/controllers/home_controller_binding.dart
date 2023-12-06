import 'package:get/get.dart';

import '../../../../presentation/home/controllers/home_controller.dart';
import '../../../../presentation/home/controllers/home_button_controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        alarmService: Get.find(),
      ),
    );
    Get.lazyPut(
      () => HomeButtonController(),
    );
  }
}
