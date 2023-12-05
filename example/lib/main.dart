import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'infrastructure/infrastructure_config.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'domain/domain_config.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  InfrastructureConfig.init();
  DomainConfig.init();

  GetMaterialApp getMaterialApp = GetMaterialApp(
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    initialRoute: await Routes.initialRoute,
    getPages: Nav.routes,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      );
    },
  );

  runApp(getMaterialApp);
}
