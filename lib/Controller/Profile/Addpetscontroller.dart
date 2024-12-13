import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PetFormController extends GetxController {
  var userId = ''.obs;
  var petName = ''.obs;
  var speciesOfPet = ''.obs;
  var breed = ''.obs;
  var size = ''.obs;
  var gender = ''.obs;
  var dob = ''.obs;
  var neutral = ''.obs;
  var vaccinated = ''.obs;
  var dogFriendly = ''.obs;
  var catFriendly = ''.obs;
  var childFriendlyUnder10 = ''.obs;
  var childFriendlyAbove10 = ''.obs;
  var microchipped = ''.obs;
  var purebred = ''.obs;
  var detail = ''.obs;
  var petImage = Rx<File?>(null);

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      petImage.value = File(pickedFile.path);
    }
  }

Future<void> submitForm() async {
  Map<String, dynamic> petData = {
    'userId': userId.value,
    'petName': petName.value,
    'species_of_pet': speciesOfPet.value,
    'breed': breed.value,
    'size': size.value,
    'gender': gender.value,
    'dob': dob.value,
    'neutral': neutral.value,
    'vaccinated': vaccinated.value,
    'dog_friendly': dogFriendly.value,
    'cat_friendly': catFriendly.value,
    'child_friendly_under_10': childFriendlyUnder10.value,
    'child_friendly_above_10': childFriendlyAbove10.value,
    'microchipped': microchipped.value,
    'purebred': purebred.value,
    'detail': detail.value,
  };

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://app.wingsandtails.in/server/mypet/addMyPet.php'), 
  );

  request.headers.addAll({
    'Content-Type': 'multipart/form-data', 
  
  });

  petData.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  if (petImage.value != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'petImage',
      petImage.value!.path,
    ));
  }

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      print("Response: ${responseData.body}");

      Get.snackbar(
        'Success',
        'Pet added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      final responseData = await http.Response.fromStream(response);
      print("Error response: ${responseData.body}");

      Get.snackbar(
        'Error',
        'Failed to add pet: ${response.reasonPhrase}\nDetails: ${responseData.body}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5), 
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Exception',
      'An error occurred: $e',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print("Exception: $e");
  }
}
}