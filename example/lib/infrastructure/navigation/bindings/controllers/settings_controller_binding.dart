import 'package:get/get.dart';

import '../../../../presentation/settings/controllers/settings_controller.dart';

class SettingsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
