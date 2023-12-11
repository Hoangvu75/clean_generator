import 'package:example/core/extensions/theme_data.dart';
import 'package:example/core/locales/app_locales.dart';
import 'package:example/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/locales/locale_keys.dart';
import '../controllers/home_controller.dart';

class HomeWidget extends GetWidget<HomeController> {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: GestureDetector(
          onTap: () {
            Get.updateLocale(
              Get.locale == AppLocales.en_US
                  ? AppLocales.vi_VN
                  : AppLocales.en_US,
            );
          },
          child: Text(
            LocaleKeys.alarm_app.tr,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
              child: Text(
                'Current theme mode: ${Get.isDarkMode ? 'Dark' : 'Light'}',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textColor,
                ),
              ),
            ),
          ),
          const MyWidget(),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _currentChildSize = 0.2;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        _currentChildSize = notification.extent;
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0.2,
        minChildSize: 0.2,
        maxChildSize: 0.5,
        snap: true,
        shouldCloseOnMinExtent: true,
        snapSizes: const [0.2, 0.5],
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Container(height: 50, color: Colors.green),
                    Container(height: 50, color: Colors.red),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
