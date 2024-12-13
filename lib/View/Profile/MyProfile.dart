import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../Controller/Profile/profilecontroller.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class MyProfile extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final pincodeController = TextEditingController();
    final addressController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              'My Profile',
              style: GoogleFonts.encodeSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.image.value != null
                            ? FileImage(controller.image.value!)
                            : controller.profileImage.value.isNotEmpty
                                ? NetworkImage(
                                    "https://app.wingsandtails.in/server/authUser/uploads/${controller.profileImage.value}")
                                : AssetImage("assets/Images/Profile.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showPicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xffED6D4E),
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(Icons.add, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // _buildTextField('Id', idController,
                //     initialValue: controller.id.value),
                // const SizedBox(height: 24),
                _buildTextField('Full Name', nameController,
                    initialValue: controller.name.value),
                const SizedBox(height: 24),
                Text('Gender', style: _labelStyle()),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGenderButton(
                        'Male',
                        Icons.male,
                        controller.isMale.value,
                        () => controller.toggleGender(true),
                      ),
                      const SizedBox(width: 20),
                      _buildGenderButton(
                        'Female',
                        Icons.female,
                        !controller.isMale.value,
                        () => controller.toggleGender(false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField('Phone', phoneController,
                    initialValue: controller.mobileNumber.value),
                const SizedBox(height: 24),
                _buildTextField(
                  'Email',
                  emailController,
                  initialValue: controller.email.value,
                ),
                const SizedBox(height: 24),
                _buildTextField('City', cityController,
                    initialValue: controller.city.value),
                const SizedBox(height: 24),
                _buildTextField('Pincode', pincodeController,
                    initialValue: controller.pincode.value),
                const SizedBox(height: 24),
                _buildTextField('Address', addressController,
                    initialValue: controller.address.value, isMultiLine: true),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Save', style: _buttonTextStyle()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffED6D4E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final response = await controller.updateUser(
                        userId: controller.id.value,
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        city: cityController.text,
                        pincode: pincodeController.text,
                        address: addressController.text,
                        gender: controller.isMale.value ? 'Male' : 'Female',
                        photo: controller.image.value,
                      );
                      if (response['status'] == 'success') {
                        controller.name.value = nameController.text;
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 3),
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          response['message'] ?? 'Update failed',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Logout', style: _buttonTextStyle()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      controller.logout();
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return GoogleFonts.encodeSans(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: const Color(0xffBBC3CE),
    );
  }

  TextStyle _buttonTextStyle() {
    return GoogleFonts.encodeSans(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: Colors.white,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isMultiLine = false,
    String? initialValue,
  }) {
    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue;
    }
    return TextField(
      controller: controller,
      maxLines: isMultiLine ? 2 : 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelStyle(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGenderButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xffED6D4E) : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
