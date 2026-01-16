import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:get/get.dart';

import 'controllers/splash.controller.dart';


// class SplashScreen extends GetView<SplashController> {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             width: Get.width,
//             height: Get.height,
//             child: Lottie.asset(
//               controller.splashLottie.value,
//               controller: controller.animationController,
//               fit: BoxFit.fill,
//               onLoaded: (composition) {
//                 controller.animationController
//                   ..duration = composition.duration
//                   ..forward();
//               },
//             ),
//           ),
//
//           /// 🔹 Payload Debug Text
//           Positioned(
//             bottom: 40,
//             left: 20,
//             right: 20,
//             child: Obx(
//                   () => Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   controller.payloadText.value,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
