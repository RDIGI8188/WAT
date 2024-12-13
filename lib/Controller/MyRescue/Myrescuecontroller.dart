import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRescueController extends GetxController {
  var rescueList = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRescueData();
  }

  Future<void> fetchRescueData() async {
    try {
      isLoading(true);
      errorMessage('');
      var url = Uri.parse(
          'https://app.wingsandtails.in/server/rescue/fetchRescueByUser.php');

      var request = http.Request('GET', url);
      request.headers.addAll({
        'Content-Type': 'application/json', // Add necessary headers if required
      });

      // Send the request
      var response = await http.Client().send(request);
      var responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200) {
        var jsonData = json.decode(responseBody.body);
        if (jsonData['status'] == 'success') {
          rescueList.assignAll(
              jsonData['data']); // Use assignAll for better performance
        } else {
          errorMessage('Failed to load data: ${jsonData['message']}');
        }
      } else {
        errorMessage('Server error: ${responseBody.statusCode}');
      }
    } catch (e) {
      errorMessage('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }
}
