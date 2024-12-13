import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:wat/Controller/bottomcontroller.dart';
import 'package:wat/View/MyRescue/MyRescue.dart';
import 'View/Home/Home.dart';
import 'View/Profile/Profile.dart';
import 'View/Updates/Booking.dart';


class Bottombar extends StatelessWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavController navController = Get.put(BottomNavController()); 

    final List<Widget> _screens = [
      HomePage(),
      BookingPage(),
      MyRescues(),
      Profile()
    ];

    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value, 
          children: _screens,
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.encodeSans(
            textStyle: TextStyle(
              color: Color(0xffED6D4E),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          currentIndex: navController.currentIndex.value, 
          onTap: (index) {
            navController.changeIndex(index); 
          },
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Image.asset(
                    "assets/Icon/BottomIcon.png",
                    height: 30,
                    width: 30,
                  )
                ],
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/Icon/iconclock.png",
                height: 30,
                width: 30,
              ),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/Icon/icon explore.png",
                height: 30,
                width: 30,
              ),
              label: 'Myrescue',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/Icon/iconprofile.png",
                height: 30,
                width: 30,
              ),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
