import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/sign_up_view.controller.dart';

class SignUpViewScreen extends GetView<SignUpViewController> {
  const SignUpViewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(controller.name),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignUpViewScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
