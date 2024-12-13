import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wat/Controller/Profile/profilecontroller.dart';
import 'package:wat/View/Profile/InviteFriend.dart';
import 'package:wat/View/Profile/Wallet.dart';
import '../../utils/color_constant.dart';
import 'Help.dart';
import 'MyProfile.dart';
import 'Myfavourites.dart';
import 'Mypets.dart';
import 'Settings.dart';

class Profile extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Stack(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 230,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 150),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Profile",
                                    style: GoogleFonts.encodeSans(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 80),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage: controller.image.value != null
                                  ? FileImage(controller
                                      .image.value!) // Display local image
                                  : controller.profileImage.value.isNotEmpty
                                      ? NetworkImage(
                                          "https://app.wingsandtails.in/server/authUser/uploads/${controller.profileImage.value}") // Display URL image
                                      : AssetImage("assets/Images/Profile.png")
                                          as ImageProvider, // Fallback
                            );
                          }),
                          const SizedBox(height: 15),
                          Obx(() {
                            return Text(
                              "${controller.name.value}",
                              style: GoogleFonts.encodeSans(
                                textStyle: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                          // Obx(() {
                          //   return CircleAvatar(
                          //     radius: 60,
                          //     backgroundImage: controller.image.value != null
                          //         ? FileImage(controller
                          //             .image.value!) // Display local image
                          //         : controller.profileImage.value.isNotEmpty
                          //             ? NetworkImage(
                          //                 "https://app.wingsandtails.in/server/authUser/uploads/${controller.profileImage.value}") // Display URL image
                          //             : AssetImage("assets/Images/Profile.png")
                          //                 as ImageProvider, // Fallback
                          //   );
                          // }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Get.to(() => EWalletPage());
                  },
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.wallet, color: ColorConstants.Button),
                    ),
                    title: Text(
                      "Wallet",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => MyProfile());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/Icon/iconprofile.png")),
                    title: Text(
                      "My Profile",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => Mypets());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20, child: Image.asset("assets/Icon/pet.png")),
                    title: Text(
                      "My Pets",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => MyFavourite());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/Icon/heart.png")),
                    title: Text(
                      "My favourites",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => InviteFriend());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/Icon/announcement.png")),
                    title: Text(
                      "Invite friends",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => HelpPage());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/Icon/question.png")),
                    title: Text(
                      "Help",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => SettingsPage());
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/Icon/settings gear.png")),
                    title: Text(
                      "Settings",
                      style: GoogleFonts.encodeSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff070821)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
