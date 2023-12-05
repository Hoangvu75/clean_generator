import 'package:get/get.dart';

import '../../../../presentation/home/controllers/home_controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        networkService: Get.find(),
        network2Service: Get.find(),
      ),
    );
  }
}
