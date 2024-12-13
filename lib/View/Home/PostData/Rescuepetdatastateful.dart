import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wat/View/Home/PostData/AddressForm.dart';

class RescuePetsPage extends StatefulWidget {
  const RescuePetsPage({Key? key}) : super(key: key);

  @override
  _RescuePetsPageState createState() => _RescuePetsPageState();
}

class _RescuePetsPageState extends State<RescuePetsPage> {
  TextEditingController textController = TextEditingController();
  List<File> imageFiles = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), 
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
              ),
            ),
            child: AppBar(
              leading: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              title: const Text(
                'Rescue Pets',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (index) {
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: index < imageFiles.length
                              ? Image.file(imageFiles[index], fit: BoxFit.cover)
                              : const Center(child: Text('No Image')),
                        ),
                        if (index < imageFiles.length)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageFiles.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    pickImages();
                    print("Upload button pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffED6D4E),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Upload Images (Max 2)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(textController, 'Describe Health Issues Here'),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () {
              print("Next button pressed");
              if (textController.text.trim().isNotEmpty &&
                  imageFiles.isNotEmpty) {
                storeDataLocally(); // Store data locally
                print("Form is complete, navigating to next page.");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressFormPage()),
                );
              } else {
                print("Form is incomplete.");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Please add images and fill in the description.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffED6D4E),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  // Image Picker
  Future<void> pickImages() async {
    final picker = ImagePicker();
    print("Attempting to pick images...");
    final pickedFiles = await picker.pickMultiImage(imageQuality: 100);

    if (pickedFiles != null && pickedFiles.length <= 2) {
      setState(() {
        imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
      print("Images picked: ${pickedFiles.length} images");
    } else {
      print("Error: Too many images selected or no images selected.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 2 images.')),
      );
    }
  }

  // Input Field Widget
  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextField(
        maxLines: 3,
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Store data locally
  void storeDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Storing data locally...");

    // Store text and images as string paths in local storage
    await prefs.setString('description', textController.text);
    print("Description saved: ${textController.text}");

    List<String> imagePaths = imageFiles.map((image) => image.path).toList();
    await prefs.setStringList('images', imagePaths);
    print("Image paths saved: $imagePaths");
  }
}
