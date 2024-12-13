import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/Auth/nboardingcontroller.dart';
import 'login.dart';




class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController()); 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                buildOnboardingPage(
                  context,
                  "assets/Images/welcome_1.png",
                  "assets/Images/1.png",
                  "Welcome to pet",
                  "All types of services for your pet in one\n        place, instantly searchable",
                  "Next",
                  Color(0xffED6D4E),
                  controller.goToNextPage, 
                ),
                Welcome2(controller), 
                Welcome3(controller),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Obx(() => buildDot(index, context, controller.currentPage.value));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardingPage(
    BuildContext context,
    String image1Path,
    String image2Path,
    String title,
    String subtitle,
    String buttonText,
    Color buttonColor,
    VoidCallback onPressed,
  ) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(flex: 2),
          Image.asset(image1Path, width: MediaQuery.of(context).size.width * 0.8),
          SizedBox(height: 5),
          Image.asset(image2Path, width: MediaQuery.of(context).size.width * 0.6),
          SizedBox(height: 30),
          Text(
            title,
            style: GoogleFonts.encodeSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Color(0xff070821),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.encodeSans(
              textStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Color(0xff070821),
              ),
            ),
          ),
          Spacer(flex: 2),
          buildResponsiveButton(context, buttonText, buttonColor, onPressed),
          Spacer(),
        ],
      ),
    );
  }
}

class Welcome2 extends StatelessWidget {
  final OnboardingController controller;
  Welcome2(this.controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Image.asset("assets/Images/Welcome_2.png", width: MediaQuery.of(context).size.width * 0.8),
              SizedBox(height: 10),
              Text(
                "Proven experts",
                style: GoogleFonts.encodeSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: Color(0xff070821),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We interview every specialist before\n                they get to work",
                textAlign: TextAlign.center,
                style: GoogleFonts.encodeSans(
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Color(0xff070821),
                  ),
                ),
              ),
              Spacer(flex: 2),
              buildResponsiveButton(context, "Next", Color(0xffED6D4E), controller.goToNextPage),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class Welcome3 extends StatelessWidget {
  final OnboardingController controller;
  Welcome3(this.controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Image.asset("assets/Images/Welcome_3.png", width: MediaQuery.of(context).size.width * 0.8),
              SizedBox(height: 10),
              Text(
                "Reliable reviews",
                style: GoogleFonts.encodeSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: Color(0xff070821),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "A review can be left only by a user\n         who used the service",
                textAlign: TextAlign.center,
                style: GoogleFonts.encodeSans(
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Color(0xff070821),
                  ),
                ),
              ),
              Spacer(flex: 2),
              buildResponsiveButton(context, "Get Started", Color(0xffED6D4E), () => Get.off(() => Login())),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildResponsiveButton(
  BuildContext context, 
  String text,
  Color color,
  VoidCallback onPressed,
) {
  return Container(
    height: 40,
    width: MediaQuery.of(context).size.width * 0.7,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.encodeSans(
          textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget buildDot(int index, BuildContext context, int currentPage) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    height: 10,
    width: (index == currentPage) ? 20 : 10,
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: (index == currentPage) ? Colors.orange : Colors.grey,
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
