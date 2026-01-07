import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:get/get.dart';

import 'controllers/splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(child: Text('SPLASH')),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Lottie.asset(
          controller.splashLottie.value,
          controller: controller.animationController,
          fit: BoxFit.fill,
          onLoaded: (composition) {
            controller.animationController
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('SplashScreen'),
    //     centerTitle: true,
    //   ),
    //   body:  Center(
    //     child: Obx(() => Text(
    //         'SplashScreen is working ${controller.count}',
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ),
    //   ),
    // );
  }
}
