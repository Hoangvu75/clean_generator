import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountButtonWidget extends GetWidget {
  const AccountButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AccountButtonWidget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AccountButtonWidget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
