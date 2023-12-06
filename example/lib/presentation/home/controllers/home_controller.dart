import 'package:get/get.dart';
import '../../../infrastructure/services/services.dart';

class HomeController extends GetxController {
  final AlarmService alarmService;
  HomeController({
    required this.alarmService,
  });

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
