import 'package:get/get.dart';

import 'source/sources.dart';

class DataConfig {
  static Future<void> init() async {
    apiDataSourceConfig();
    localDataSourceConfig();
    socketDataSourceConfig();
  }

  static void apiDataSourceConfig() {
    Get.lazyPut(() => AuthApiClient());
    Get.lazyPut(() => FriendApiClient());
  }

  static void localDataSourceConfig() {}

  static void socketDataSourceConfig() {}
}
