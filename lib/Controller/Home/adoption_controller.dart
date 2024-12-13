import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:wat/Model/pet.dart';

class AdoptionController extends GetxController {
  var pets = <Pet>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPets();
    super.onInit();
  }

  void fetchPets() async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('https://app.wingsandtails.in/server/adoption/getAllAdoption.php'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;

      final sortedData = data.map((pet) => Pet.fromJson(pet)).toList()
        ..sort((a, b) {
          DateTime dateA = _parseTimestamp(a.currentTimeStamp);
          DateTime dateB = _parseTimestamp(b.currentTimeStamp);
          return dateB.compareTo(dateA); 
        });

      pets.value = sortedData;
    } else {
      print("Failed to load pets");
    }
    isLoading.value = false;
  }

  DateTime _parseTimestamp(String timestamp) {
    try {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
    } catch (e) {
      return DateTime.now();
    }
  }
}
