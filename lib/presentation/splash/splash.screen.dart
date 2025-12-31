import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreen'),
        centerTitle: true,
      ),
      body:  Center(
        child: Obx(() => Text(
            'SplashScreen is working ${controller.count}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
