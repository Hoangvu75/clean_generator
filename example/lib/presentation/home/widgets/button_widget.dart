import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget extends GetWidget {
  const ButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ButtonWidget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ButtonWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
