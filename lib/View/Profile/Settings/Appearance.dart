import 'package:flutter/material.dart';

class AppearancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Appearance'),
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
        body: Center(child: Text('This is the Appearance Page')),
      ),
    );
  }
}