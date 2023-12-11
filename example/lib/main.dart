import 'package:example/core/extensions/string.dart';
import 'package:example/core/locales/locale_keys.dart';
import 'package:example/core/locales/app_locales.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/data_config.dart';
import 'infrastructure/infrastructure_config.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'domain/domain_config.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  DataConfig.init();
  DomainConfig.init();
  InfrastructureConfig.init();

  GetMaterialApp getMaterialApp = GetMaterialApp(
    themeMode: ThemeMode.dark,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    translationsKeys: AppTranslation.translations,
    locale: AppLocales.en_US,
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
