import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RescueController extends GetxController {
  var rescues = <Rescue>[].obs; 
  var isLoading = true.obs; 
  var errorMessage = ''.obs; 

  final String apiUrl = 'https://app.wingsandtails.in/server/rescue/fetchRescueByUser.php';

  @override
  void onInit() {
    fetchRescues(); 
    super.onInit();
  }

  Future<void> fetchRescues() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> rescueList = jsonResponse['data'];
          rescues.value = rescueList.map((rescue) => Rescue.fromJson(rescue)).toList();
        } else {
          errorMessage.value = 'Failed to load rescues';
        }
      } else {
        errorMessage.value = 'Failed to load rescues';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load rescues: $e';
    } finally {
      isLoading(false);
    }
  }
}

class Rescue {
  final int id;
  final String username;
  final String text;
  final String address;
  final String location;
  final String taskAssignedTo;
  final String status;
  final String currentTimestamp;
  final List<String> images;

  Rescue({
    required this.id,
    required this.username,
    required this.text,
    required this.address,
    required this.location,
    required this.taskAssignedTo,
    required this.status,
    required this.currentTimestamp,
    required this.images,
  });

  factory Rescue.fromJson(Map<String, dynamic> json) {
    return Rescue(
      id: json['id'],
      username: json['username'],
      text: json['text'],
      address: json['address'],
      location: json['location'],
      taskAssignedTo: json['task_assigned_to'],
      status: json['status'].toString(),
      currentTimestamp: json['currenttimestamp'],
      images: (json['images'] as String).split(',').map((img) => 'https://app.wingsandtails.in/server/rescue/$img').toList(),
    );
  }
}
