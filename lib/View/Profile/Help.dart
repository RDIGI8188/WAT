
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  final List<HelpItem> helpTopics = [
    HelpItem(icon: Icons.info, title: 'FAQ', route: '/faq'),
    HelpItem(icon: Icons.feedback, title: 'Send Feedback', route: '/feedback'),
    HelpItem(icon: Icons.report_problem, title: 'Report a Problem', route: '/report'),
    HelpItem(icon: Icons.phone, title: 'Contact Us', route: '/contact'),
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
          title: Text('Help & Support'),
        ),
        body: ListView.separated(
          itemCount: helpTopics.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(helpTopics[index].icon),
              title: Text(helpTopics[index].title),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                if (helpTopics[index].route == '/contact') {
                  await _phone(); 
                } else {
                  _showProfessionalAlert(context, helpTopics[index].title);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _phone() async {
    final Uri phoneUrl = Uri(
      scheme: "tel",
      path: "919028793459", 
    );

    if (!await launchUrl(phoneUrl)) {
      throw Exception('Could not launch $phoneUrl');
    }
  }

  void _showProfessionalAlert(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Image.asset(
                'assets/Images/logo.png', 
                height: 50,
                width: 50,
              ),
              SizedBox(height: 10),
              Text(
                '$title - Coming Soon',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank you for your interest! This feature is currently in development and will be available shortly.\nStay tuned for updates.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Color(0xffED6D4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Got it!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
}

class HelpItem {
  final IconData icon;
  final String title;
  final String route;

  HelpItem({required this.icon, required this.title, required this.route});
}

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HelpPage()),
        GetPage(name: '/faq', page: () => FAQPage()),
        GetPage(name: '/feedback', page: () => FeedbackPage()),
        GetPage(name: '/report', page: () => ReportPage()),
      ],
    ),
  );
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQ')),
      body: Center(child: Text('This is the FAQ Page')),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Feedback')),
      body: Center(child: Text('This is the Feedback Page')),
    );
  }
}

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report a Problem')),
      body: Center(child: Text('This is the Report a Problem Page')),
    );
  }
}
