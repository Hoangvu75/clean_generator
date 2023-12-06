import 'package:get/get.dart';

import 'repositories/repositories.dart';

class DomainConfig {
  static void init() {
    repositoryConfig();
  }

  static void repositoryConfig() {
    Get.lazyPut(
      () => AuthRepository(
        authApiClient: Get.find(),
      ),
    );
    Get.lazyPut(
      () => AccountRepository(),
    );
    Get.lazyPut(
      () => UserRepository(
        authApiClient: Get.find(),
      ),
    );
  }
}
