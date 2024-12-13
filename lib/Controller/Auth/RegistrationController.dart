import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:wat/bottombar.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  Future<void> generateOtp() async {
    String mobileNumber = mobileController.text.trim();

    if (mobileNumber.isEmpty || mobileNumber.length < 10) {
      Get.snackbar(
        "Error",
        "Please enter a valid mobile number (at least 10 digits).",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }

    final url =
        Uri.parse('https://app.wingsandtails.in/server/authUser/mobileOtp.php');
    try {
      final response = await http.post(url, body: {'mobile': mobileNumber});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] ?? false) {
          Get.snackbar(
            "Success",
            "OTP sent to your mobile number.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? "Failed to send OTP.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to send OTP. Please try again.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String mobileNumber = mobileController.text.trim();
    String otp = otpController.text.trim();
    String referralcode = referralController.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter your name.");
      return;
    }
    if (email.isEmpty || !_isEmailValid(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }
    if (mobileNumber.isEmpty || mobileNumber.length < 10) {
      Get.snackbar(
        "Error",
        "Please enter a valid mobile number (at least 10 digits).",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }
    if (otp.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter the OTP.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return;
    }

    final url = Uri.parse(
        'https://app.wingsandtails.in/server/authUser/appRegistration.php');
    try {
      final response = await http.post(url, body: {
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'otp': otp,
        'referralCode': referralcode,
      });

      if (response.statusCode == 200) {
        String responseBody = response.body;

        if (responseBody.contains('{')) {
          responseBody = responseBody.substring(responseBody.indexOf('{'));
        }

        final Map<String, dynamic> responseData = json.decode(responseBody);

        bool isSuccess = responseData['success'] ?? false;

        if (isSuccess) {
          Get.snackbar(
            "Success",
            "Registration successful! Welcome, $name!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Store user data in SharedPreferences
          await _saveUserData(responseData);

          // Navigate to profile or main page
          Get.offAll(() => Bottombar());
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? "Unknown error occurred.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to register. Please try again.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  bool _isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', userData['user_id'] ?? '');
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString('mobile', userData['mobile'] ?? '');
    await prefs.setString('user_city', userData['city'] ?? '');
    await prefs.setString('user_pincode', userData['pincode'] ?? '');
    await prefs.setString('user_gender', userData['gender'] ?? '');
    await prefs.setString(
        'user_profile_image', userData['profile_image'] ?? '');
  }
}
