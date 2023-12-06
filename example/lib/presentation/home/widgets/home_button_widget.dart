import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeButtonWidget extends GetWidget {
  const HomeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeButtonWidget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeButtonWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
