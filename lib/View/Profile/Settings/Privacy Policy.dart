import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  Future<String> fetchPrivacyPolicy() async {
    final response = await http.get(Uri.parse('https://app.wingsandtails.in/server/pages/Policies/privacyPolicy/getPol.php'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['privacy_policy']; 
      } else {
        throw Exception('Failed to load privacy policy: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to fetch privacy policy with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
              ),
            ),
          ),
        ),
        body: FutureBuilder<String>(
          future: fetchPrivacyPolicy(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.data ?? 'No privacy policy available',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
