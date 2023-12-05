import 'package:get/get.dart';
import '../../../infrastructure/services/services.dart';

class HomeController extends GetxController {
  final NetworkService networkService;
  final Network2Service network2Service;
  HomeController({
    required this.networkService,
    required this.network2Service,
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
