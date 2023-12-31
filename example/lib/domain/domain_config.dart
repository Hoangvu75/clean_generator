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
        friendApiClient: Get.find(),
      ),
    );
    Get.lazyPut(
      () => FriendRepository(
        friendApiClient: Get.find(),
        authApiClient: Get.find(),
      ),
    );
  }
}
