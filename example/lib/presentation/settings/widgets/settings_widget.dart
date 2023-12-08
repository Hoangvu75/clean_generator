import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/locales/locale_keys.dart';
import '../controllers/settings_controller.dart';

class SettingsWidget extends GetWidget<SettingsController> {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.day.tr,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingsWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
