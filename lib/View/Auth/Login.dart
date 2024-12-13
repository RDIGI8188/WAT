import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Auth/Logincontroller.dart';
import 'RegistrationPage.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 216, 91, 53),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: loginController.formKey,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Welcome',
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'to',
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wings and Tails',
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Log in to your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Welcome back! Please enter your details.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      labelText: 'Phone',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (loginController.formKey.currentState!
                                .validate()) {
                              loginController.generateAndSendOtp();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      loginController.phoneNumber.value = value;
                    },
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      hintText: 'Enter OTP',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (value) {
                      loginController.otp.value = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (loginController.otp.value.length == 6) {
                        loginController.verifyOtpAndLogin();
                      } else {
                        Get.snackbar('Error', 'Please enter a valid OTP',
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 70),
                    child: InkWell(
                      onTap: () {
                        Get.off(Register());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Dont have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Get.off(Register());
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff4552CB)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
