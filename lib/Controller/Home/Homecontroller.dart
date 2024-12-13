import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var isLoading = true.obs;
  var sliderData = <Map<String, dynamic>>[].obs; 
  var activeIndex = 0.obs;

  @override
  void onInit() {
    fetchSliderData();
    super.onInit();
  }

  Future<void> fetchSliderData() async {
    try {
      final response = await http.get(Uri.parse('https://app.wingsandtails.in/server/pages/slider/getSlider.php'));
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          sliderData.value = List<Map<String, dynamic>>.from(jsonResponse['data']);
        } else {
          Get.snackbar('Error', 'Failed to load slider data: ${jsonResponse['status']}');
        }
      } else {
        Get.snackbar('Error', 'Failed to load slider data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching data: $e');
    } finally {
      isLoading.value = false; 
    }
  }

  void updateActiveIndex(int index) {
    activeIndex.value = index;
  }
}
