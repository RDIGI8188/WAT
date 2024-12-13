import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../Controller/Profile/Addpetscontroller.dart';

class PetFormPage extends StatelessWidget {
  final PetFormController controller = Get.put(PetFormController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet'),
        
        centerTitle: true,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'User ID',
                    onChanged: (value) => controller.userId.value = value,
                  ),
                  _buildTextField(
                    label: 'Pet Name',
                    onChanged: (value) => controller.petName.value = value,
                  ),
                  _buildTextField(
                    label: 'Species of Pet',
                    onChanged: (value) => controller.speciesOfPet.value = value,
                  ),
                  _buildTextField(
                    label: 'Breed',
                    onChanged: (value) => controller.breed.value = value,
                  ),
                  _buildTextField(
                    label: 'Size',
                    onChanged: (value) => controller.size.value = value,
                  ),
                  _buildTextField(
                    label: 'Gender',
                    onChanged: (value) => controller.gender.value = value,
                  ),
                  _buildTextField(
                    label: 'Date of Birth',
                    onChanged: (value) => controller.dob.value = value,
                  ),
                  _buildTextField(
                    label: 'Neutral',
                    onChanged: (value) => controller.neutral.value = value,
                  ),
                  _buildTextField(
                    label: 'Vaccinated',
                    onChanged: (value) => controller.vaccinated.value = value,
                  ),
                  _buildTextField(
                    label: 'Dog Friendly',
                    onChanged: (value) => controller.dogFriendly.value = value,
                  ),
                  _buildTextField(
                    label: 'Cat Friendly',
                    onChanged: (value) => controller.catFriendly.value = value,
                  ),
                  _buildTextField(
                    label: 'Child Friendly (<10)',
                    onChanged: (value) => controller.childFriendlyUnder10.value = value,
                  ),
                  _buildTextField(
                    label: 'Child Friendly (>10)',
                    onChanged: (value) => controller.childFriendlyAbove10.value = value,
                  ),
                  _buildTextField(
                    label: 'Microchipped',
                    onChanged: (value) => controller.microchipped.value = value,
                  ),
                  _buildTextField(
                    label: 'Purebred',
                    onChanged: (value) => controller.purebred.value = value,
                  ),
                  _buildTextField(
                    label: 'Details',
                    maxLines: 4,
                    onChanged: (value) => controller.detail.value = value,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => controller.pickImage(),
                    child: Text(
                      'Select Pet Image',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (controller.petImage.value != null)
                    Image.file(
                      File(controller.petImage.value!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.submitForm();
                        }
                      },
                      child: Text('Submit'),
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

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
