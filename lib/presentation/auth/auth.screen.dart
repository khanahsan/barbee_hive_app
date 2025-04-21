import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/auth.controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
