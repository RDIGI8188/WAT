import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart'; // For file path manipulation
import 'package:mime/mime.dart'; // For determining file MIME type
import 'package:http_parser/http_parser.dart'; // For parsing MIME types
import 'package:wat/View/Auth/splash.dart';

class ProfileController extends GetxController {
  RxBool isMale = true.obs;
  Rx<File?> image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  RxString mobileNumber = ''.obs;
  RxString id = ''.obs;
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString city = ''.obs;
  RxString pincode = ''.obs;
  RxString address = ''.obs;
  RxString referral_code = ''.obs;
  RxString wallet_amt = ''.obs;
  RxString profileImage = ''.obs;

  var gender;

  @override
  void onInit() {
    super.onInit();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber.value = prefs.getString('mobile') ?? '';
    id.value = prefs.getString('user_id') ?? '';
    email.value = prefs.getString('user_email') ?? '';
    name.value = prefs.getString('user_name') ?? '';
    city.value = prefs.getString('user_city') ?? '';
    pincode.value = prefs.getString('user_pincode') ?? '';
    address.value = prefs.getString('customer_address') ?? '';
    referral_code.value = prefs.getString('referal_code') ?? '';
    wallet_amt.value = prefs.getString('wallet_amt') ?? '';
    profileImage.value = prefs.getString('user_profile_image') ?? '';
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  void toggleGender(bool male) {
    isMale.value = male;
  }

  Future<Map<String, dynamic>> updateUser({
    required String userId,
    required String? gender,
    required String? city,
    required String? pincode,
    required String? address,
    File? photo,
    required String name,
    required String email,
    required String phone,
  }) async {
    const String apiUrl =
        'https://app.wingsandtails.in/server/authUser/updateProfile.php'; // Replace with your PHP API URL

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['user_id'] = userId;
      if (gender != null) request.fields['gender'] = gender;
      if (city != null) request.fields['city'] = city;
      if (pincode != null) request.fields['pincode'] = pincode;
      if (address != null) request.fields['address'] = address;
       request.fields['name'] = name;
      // Add photo if provided
      if (photo != null) {
        final mimeType = lookupMimeType(photo.path); // Get the MIME type
        if (mimeType != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo',
              photo.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        }
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else {
        return {'status': 'error', 'message': 'Failed to update user details.'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'An error occurred: $e'};
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', userDetails['mobile'] ?? '');
    await prefs.setString('user_id', userDetails['user_id']?.toString() ?? '');
    await prefs.setString('user_name', userDetails['user_name'] ?? '');
    await prefs.setString('user_email', userDetails['user_email'] ?? '');
    await prefs.setString('user_gender', userDetails['user_gender'] ?? '');
    await prefs.setString('user_city', userDetails['user_city'] ?? '');
    await prefs.setString('user_pincode', userDetails['user_pincode'] ?? '');
    await prefs.setString(
        'user_profile_image', userDetails['user_profile_image'] ?? '');
    await prefs.setString('referal_code', userDetails['referal_code'] ?? '');
    await prefs.setString(
        'wallet_amt', userDetails['wallet_amt']?.toString() ?? '');
    name.value = userDetails['user_name'] ?? '';
    print(
        "User data saved: ${userDetails['user_name']} with mobile: ${userDetails['mobile']}");
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(Splash());
  }
}
