import 'package:get/get.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../infrastructure/services/services.dart';

class HomeController extends GetxController {
  final AlarmService alarmService;
  final AuthRepository authRepository;
  HomeController({
    required this.alarmService,
    required this.authRepository,
  });

  final count = 0.obs;

  @override
  void onInit() {
    authRepository.login('email', 'password');
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
