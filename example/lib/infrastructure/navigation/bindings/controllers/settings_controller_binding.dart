import 'package:get/get.dart';

import '../../../../presentation/settings/controllers/settings_controller.dart';
import '../../../../presentation/settings/controllers/switcher_controller.dart';

class SettingsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingsController(
        alarmMethodChannelService: Get.find(),
      ),
    );
    Get.lazyPut(
      () => SwitcherController(),
    );
  }
}
