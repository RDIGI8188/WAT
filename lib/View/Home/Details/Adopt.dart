

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddPetDetailPagesss extends StatelessWidget {
  final AddPetDetailController controller = Get.put(AddPetDetailController());

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Pet Details',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
             //   _buildTextField(controller.idController, 'ID'),
             //   _buildTextField(controller.userIdController, 'User ID'),
            //    _buildTextField(controller.petIdController, 'Pet ID'),
                _buildTextField(controller.petDetailController, 'Pet Detail'),
                _buildTextField(controller.reasonController, 'Reason'),
                _buildTextField(controller.addressController, 'Address'),

                // Gender Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedGender.value,
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedGender.value = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Age Date Picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    controller: controller.ageController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Age (in years)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onTap: () => controller.selectDate(context),
                  ),
                ),

                _buildTextField(controller.colorController, 'Color'),
                _buildTextField(controller.breedController, 'Breed'),

                // Display Selected Images
                Obx(
                  () => controller.imageFiles.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selected Images:', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.imageFiles.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.file(
                                      File(controller.imageFiles[index].path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                SizedBox(height: 20),

                // Elevated Button for Image Selection
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.pickImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffED6D4E),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Select Images (Max: 4)', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 20),

                // Submit Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffED6D4E),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddPetDetailController extends GetxController {
  final TextEditingController idController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController petIdController = TextEditingController();
  final TextEditingController petDetailController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController breedController = TextEditingController();

  var selectedGender = 'Male'.obs; 
  var imageFiles = <XFile>[].obs; 

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.length <= 4) {
      imageFiles.assignAll(images);
    } else {
      Get.snackbar('Error', 'Please select up to 4 images.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> submitData() async {
    if (imageFiles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://app.wingsandtails.in/server/adoption/booking.php'),
    );
    request.fields['id'] = idController.text;
    request.fields['userId'] = userIdController.text;
    request.fields['petId'] = petIdController.text;
    request.fields['petDetail'] = petDetailController.text;
    request.fields['reason'] = reasonController.text;
    request.fields['address'] = addressController.text;
    request.fields['gender'] = selectedGender.value;
    request.fields['age'] = ageController.text;
    request.fields['color'] = colorController.text;
    request.fields['breed'] = breedController.text;

    for (var imageFile in imageFiles) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'rescue_img[]',
          imageFile.path,
        ),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Pet details submitted successfully.',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to submit pet details.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      int age = DateTime.now().year - pickedDate.year;
      if (DateTime.now().isBefore(DateTime(pickedDate.year, pickedDate.month, pickedDate.day))) {
        age--;
      }
      ageController.text = age.toString();
    }
  }
}
