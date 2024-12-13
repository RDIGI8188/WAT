import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/Auth/splashcontroller.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF1A852), Color(0xffED6D4E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Image.asset(
                "assets/dog.png",
                height: 250,
                width: 250,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Wings and Tails",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
