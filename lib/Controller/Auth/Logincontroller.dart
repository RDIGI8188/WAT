import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../bottombar.dart';

class ApiService {
  static const String baseUrl =
      'https://app.wingsandtails.in/server/authUser/appLogin.php';

  String? generatedOtp;

  Future<void> generateOtp(String mobile) async {
    print("Generating OTP for mobile: $mobile",);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'action': 'generate',
        'mobile': mobile,
      },
    );

    print("Response from generate OTP: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          generatedOtp = jsonResponse['otp'].toString();
          print('OTP Generated: ${jsonResponse['message']}');
        } else {
          print('Failed to generate OTP: ${jsonResponse['message']}',);
          throw Exception(jsonResponse['message'] ?? 'Failed to generate OTP');
        }
    } else {
      print('Server error when generating OTP: ${response.statusCode}');
      throw Exception('Failed to generate OTP',);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    print("Verifying OTP for mobile: $mobile with OTP: $otp",);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'action': 'verify',
        'mobile': mobile,
        'otp': otp.trim(),
      },
    );

    print("Response from verify OTP: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response JSON: $jsonResponse');

      if (jsonResponse['Status'] == 'Success') {
        print('OTP Verified: ${jsonResponse['message']}',);
        return jsonResponse; // Return full response
      } else {
        print('OTP verification failed: ${jsonResponse['message']}');
        throw Exception(jsonResponse['message'] ?? 'OTP verification failed',);
      }
    } else {
      print('Server error when verifying OTP: ${response.statusCode}');
      throw Exception('Failed to verify OTP');
    }
  }
}

class LoginController extends GetxController {
  final phoneNumber = ''.obs;
  final otp = ''.obs;
  final formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile != null) {
      print("User is already logged in with mobile: $mobile");
      Get.offAll(() => Bottombar());
    } else {
      print("User is not logged in.");
    }
  }

  Future<void> generateAndSendOtp() async {
    if (phoneNumber.value.isNotEmpty) {
      print(
          "Attempting to generate and send OTP for mobile: ${phoneNumber.value}");
      try {
        await apiService.generateOtp(phoneNumber.value);
        Get.snackbar(
          'OTP Sent',
          'A new OTP has been sent successfully to ${phoneNumber.value}.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        otp.value = '';
      } catch (e) {
        showError('An error occurred while sending OTP: $e');
      }
    } else {
      showError('Please enter a valid phone number.');
    }
  }

  Future<void> verifyOtpAndLogin() async {
    if (otp.value.isNotEmpty) {
      print(
          "Attempting to verify OTP: ${otp.value} for mobile: ${phoneNumber.value}");
      try {
        final userDetails =
            await apiService.verifyOtp(phoneNumber.value, otp.value.trim());

        if (userDetails['Status'] == 'Success') {
          print("Login successful. User details: $userDetails");
          if (userDetails.containsKey('user_id') &&
              userDetails['user_id'] != null) {
            await saveUserData(userDetails);
            Get.snackbar('Success', 'Login successful!',
                backgroundColor: Colors.green, colorText: Colors.white);
            Get.offAll(() => Bottombar());
          } else {
            showError('User details are missing. Please try again.');
          }
        }
      } catch (e) {
        print("Error during OTP verification: $e");
        String errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('otp has expired')) {
          showError('OTP has expired. Please request a new OTP.');
        } else if (errorMessage.contains('otp verification failed')) {
          showError('Incorrect OTP entered. Please try again.');
        } else {
          showError('An error occurred while verifying OTP: $e');
        }
      }
    } else {
      showError('Please enter the OTP.');
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', userDetails['mobile'] ?? '');
    await prefs.setString('user_id', userDetails['user_id']?.toString() ?? '');
    await prefs.setString('user_name', userDetails['user_name'] ?? '');
    await prefs.setString('user_email', userDetails['user_email'] ?? '');
    await prefs.setString('user_gender', userDetails['user_gender'] ?? '');
    await prefs.setString('user_city', userDetails['user_city'] ?? '');
    await prefs.setString('user_pincode', userDetails['user_pincode'] ?? '');
    await prefs.setString('customer_address', userDetails['customer_address'] ?? '');
    await prefs.setString('referal_code', userDetails['referal_code'] ?? '');
    
    await prefs.setString(
        'user_profile_image', userDetails['user_profile_image'] ?? '');
    await prefs.setString(
        'wallet_amt', userDetails['wallet_amt']?.toString() ?? '');
    print(
        "User data saved: ${userDetails['user_name']} with mobile: ${userDetails['mobile']}");
  }


  void showError(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }
}
