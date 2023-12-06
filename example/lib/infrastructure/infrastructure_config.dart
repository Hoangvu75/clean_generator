import 'package:get/get.dart';

import 'services/services.dart';

class InfrastructureConfig {
  static void init() {
    serviceConfig();
  }

  static void serviceConfig() {
    Get.put(AlarmService());
  }
}
