import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddressFormController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitForm(
      String id,
      String username,
      String detail,
      String address,
      String latitude,
      String longitude,
      List<File> rescue_img) async {
    isLoading.value = true;  
    print("Debug: Start of submitForm");

    if ([id, username, detail, address, latitude, longitude]
            .any((e) => e.isEmpty) ||
        rescue_img.isEmpty) {
      print("Debug: Validation failed - Missing required fields");
      Get.snackbar('Error', 'Please fill all the required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    print("Debug: Validation passed");

    try {
      var uri =
          Uri.parse('https://app.wingsandtails.in/server/rescue/addRescue.php');
      print("Debug: URI initialized - $uri");

      var request = http.MultipartRequest('POST', uri);
      print("Debug: MultipartRequest created");

      request.fields['id'] = id;
      request.fields['username'] = username;
      request.fields['detail'] = detail;
      request.fields['address'] = address;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      print(
          "Debug: Fields added to request - $id, $username, $detail, $address, $latitude, $longitude");

      if (rescue_img.isNotEmpty) {
        for (var image in rescue_img) {
          print("Debug: Checking if image exists - ${image.path}");
          if (await image.exists()) {
            request.files.add(
                await http.MultipartFile.fromPath('rescue_img[]', image.path));
            print("Debug: Image added to request - ${image.path}");
          } else {
            print("Debug: Image file does not exist - ${image.path}");
            Get.snackbar('Error', 'Image file does not exist',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } else {
        print("Debug: No images provided");
      }

      print("Debug: Sending request...");
      var response = await request.send();
      print(
          "Debug: Response received with status code - ${response.statusCode}");

      var responseBody = await response.stream.bytesToString();
      print("Debug: Response body - $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          var jsonResponse = jsonDecode(responseBody);
          print("Debug: JSON response parsed - $jsonResponse");

          if (jsonResponse is Map && jsonResponse['success'] == true) {
            print("Debug: Success - ${jsonResponse['message']}");
            Get.snackbar('Success',
                jsonResponse['message'] ?? 'Rescue added successfully!',
                backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            print(
                "Debug: Error message from server - ${jsonResponse['message']}");
            Get.snackbar(
                'Error', jsonResponse['message'] ?? 'Submission failed!',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } catch (e) {
          print("Debug: JSON parsing error - $e");
          Get.snackbar('Error', 'Invalid response: $e',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        print(
            "Debug: Request failed with status code - ${response.statusCode}");
        Get.snackbar('Error', 'Failed with status: ${response.statusCode}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Debug: Exception occurred - $e");
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      print("Debug: End of submitForm");
    }
  }
}
