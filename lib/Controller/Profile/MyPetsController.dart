import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PetController extends GetxController {
  var pets = <dynamic>[].obs; 

  @override
  void onInit() {
    fetchPets();
    super.onInit();
  }

  Future<void> fetchPets() async {
    final response = await http.get(Uri.parse('https://app.wingsandtails.in/server/mypet/getAllPet.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      pets.assignAll(data); 
    } else {
      print('Failed to load pets');
    }
  }
}
