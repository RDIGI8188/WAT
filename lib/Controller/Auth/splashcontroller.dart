
import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wat/bottombar.dart';
import '../../View/Auth/OnboardingScreen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("Splash Screen Initialized");

    Timer(
      Duration(seconds: 3),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? mobile = prefs.getString('mobile');

        if (mobile != null) {
          Get.off(() => Bottombar()); 
        } else {
          Get.off(() => OnboardingScreen());
        }
      },
    );
  }
}
