import 'package:get/get.dart';

class HomeButtonController extends GetxController {
  HomeButtonController();

  final count = 0.obs;

  @override
  void onInit() {
    //TODO: Implement SettingsController
    super.onInit();
  }

  @override
  void onReady() {
    //TODO: Implement SettingsController
    super.onReady();
  }

  @override
  void onClose() {
    //TODO: Implement SettingsController
    super.onClose();
  }

  void increment() => count.value++;
}
