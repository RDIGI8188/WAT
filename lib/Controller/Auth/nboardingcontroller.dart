import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../View/Auth/Login.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs; 

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void goToNextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Get.off(() => Login());
    }
  }
}
