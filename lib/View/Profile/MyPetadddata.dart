
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddMyPetPage extends StatefulWidget {
  @override
  _AddMyPetPageState createState() => _AddMyPetPageState();
}

class _AddMyPetPageState extends State<AddMyPetPage> {
  final Color primaryColor = const Color(0xffED6D4E);

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  
  String? selectedGender;
  DateTime? selectedDob;
  XFile? _petImage;

  int neutralStatus = 0;
  int vaccinatedStatus = 0;
  int dogFriendlyStatus = 0;
  int catFriendlyStatus = 0;
  int childFriendly10AboveStatus = 0;
  int childFriendly10BelowStatus = 0;
  int microchippedStatus = 0;
  int purebredStatus = 0;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _petImage = image;
      });
    }
  }

  Future<void> pickDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDob = pickedDate;
      });
    }
  }

  Future<void> submitPetDetails() async {
    if (_petImage == null) {
      Get.snackbar('Error', 'Please select an image for the pet.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedDob == null) {
      Get.snackbar('Error', 'Please select a date of birth for the pet.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedGender == null) {
      Get.snackbar('Error', 'Please select the gender for the pet.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://app.wingsandtails.in/server/mypet/addMyPet.php'),
    );

    request.fields['userId'] = userIdController.text;
    request.fields['petName'] = petNameController.text;
    request.fields['species_of_pet'] = speciesController.text;
    request.fields['breed'] = breedController.text;
    request.fields['size'] = sizeController.text;
    request.fields['gender'] = selectedGender!;
    request.fields['dob'] = DateFormat('yyyy-MM-dd').format(selectedDob!);
    request.fields['neutral'] = neutralStatus.toString();
    request.fields['vaccinated'] = vaccinatedStatus.toString();
    request.fields['dog_friendly'] = dogFriendlyStatus.toString();
    request.fields['cat_friendly'] = catFriendlyStatus.toString();
    request.fields['10years>child_friendly'] = childFriendly10AboveStatus.toString();
    request.fields['10years<child_friendly'] = childFriendly10BelowStatus.toString();
    request.fields['microchipped'] = microchippedStatus.toString();
    request.fields['purebred'] = purebredStatus.toString();
    request.fields['detail'] = detailController.text;

    request.files.add(
      await http.MultipartFile.fromPath(
        'petImage',
        _petImage!.path,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Pet details submitted successfully.',
            backgroundColor: Colors.green, colorText: Colors.white);
        userIdController.clear();
        petNameController.clear();
        speciesController.clear();
        breedController.clear();
        sizeController.clear();
        detailController.clear();
        setState(() {
          selectedGender = null;
          selectedDob = null;
          _petImage = null;
        });
      } else {
        Get.snackbar('Error', 'Failed to submit pet details.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSwitch({required String label, required bool value, required Function(bool) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: pickDateOfBirth,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          selectedDob == null
              ? 'Select Date of Birth'
              : DateFormat('yyyy-MM-dd').format(selectedDob!),
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      value: selectedGender,
      items: ['Male', 'Female', 'Other'].map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = value;
        });
      },
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _petImage == null
                ? Center(child: Text('Select an Image'))
                : Image.file(File(_petImage!.path), fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Add My Pet',style: TextStyle(color: Colors.white),), backgroundColor: primaryColor,
         flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
              ),
            ),
          ),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(label: 'User ID', controller: userIdController),
                _buildTextField(label: 'Pet Name', controller: petNameController),
                _buildTextField(label: 'Species of Pet', controller: speciesController),
                _buildTextField(label: 'Breed', controller: breedController),
                _buildTextField(label: 'Size', controller: sizeController),
      
                SizedBox(height: 10),
      
                _buildGenderDropdown(),
      
                SizedBox(height: 10),
      
                _buildDatePickerField(),
      
                SizedBox(height: 10),
                _buildTextField(label: 'Detail', controller: detailController),
      
                SizedBox(height: 10),
                _buildImagePicker(),
      
                _buildSwitch(
                  label: 'Neutral', 
                  value: neutralStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      neutralStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Vaccinated', 
                  value: vaccinatedStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      vaccinatedStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Dog Friendly', 
                  value: dogFriendlyStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      dogFriendlyStatus = value ? 1 : 0;
                    });
                  },
                ),
                              _buildSwitch(
                  label: 'Cat Friendly', 
                  value: catFriendlyStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      catFriendlyStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Child Friendly (10 years and above)', 
                  value: childFriendly10AboveStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      childFriendly10AboveStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Child Friendly (10 years and below)', 
                  value: childFriendly10BelowStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      childFriendly10BelowStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Microchipped', 
                  value: microchippedStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      microchippedStatus = value ? 1 : 0;
                    });
                  },
                ),
                _buildSwitch(
                  label: 'Purebred', 
                  value: purebredStatus == 1, 
                  onChanged: (value) {
                    setState(() {
                      purebredStatus = value ? 1 : 0;
                    });
                  },
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  
                  onPressed: submitPetDetails,
                  child: Center(
                    child: Text('Submit Pet Details',
                    style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xffED6D4E)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
