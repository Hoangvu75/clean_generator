import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeWidget(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsWidget(),
      binding: SettingsControllerBinding(),
    ),
    GetPage(
      name: Routes.ALARM_CLOCK,
      page: () => const AlarmClockWidget(),
      binding: AlarmClockControllerBinding(),
    ),
  ];
}
