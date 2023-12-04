import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeWidget extends GetWidget<HomeController> {
  const HomeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeWidget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
