import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddListingController extends GetxController {
  var images = <File>[].obs; 

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null && images.length < 4) {
      images.add(File(image.path)); 
    }
  }

  void removeImage(int index) {
    images.removeAt(index); 
  }
}
