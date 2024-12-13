import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wat/View/Profile/Settings/Privacy%20Policy.dart';
import 'package:wat/View/Profile/Settings/Terms%20&%20Conditions.dart';

import 'Settings/About.dart';
import 'Settings/Appearance.dart';

class SettingsPage extends StatelessWidget {
  final List<SettingItem> settings = [
    SettingItem(icon: Icons.info, title: 'About', page: AboutPage()),
    SettingItem(icon: Icons.visibility, title: 'Appearance', page: AppearancePage()),
    SettingItem(icon: Icons.security, title: 'Privacy Policy', page: PrivacyPolicyPage()),
    SettingItem(icon: Icons.policy, title: 'Terms & Conditions', page: TermsAndConditionsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          centerTitle: true,
          title: Text('Settings'),
        ),
        body: ListView.separated(
          itemCount: settings.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(settings[index].icon),
              title: Text(settings[index].title),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => settings[index].page);
              },
            );
          },
        ),
      ),
    );
  }
}

class SettingItem {
  final IconData icon;
  final String title;
  final Widget page; 

  SettingItem({required this.icon, required this.title, required this.page});
}





