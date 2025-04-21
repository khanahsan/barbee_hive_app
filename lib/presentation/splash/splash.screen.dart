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
      body: const Center(
        child: Text(
          'SplashScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
