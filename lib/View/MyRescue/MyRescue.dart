import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wat/Controller/MyRescue/Myrescuecontroller.dart';
import 'package:wat/Model/MyRescueservicecard.dart';
import 'package:wat/View/Home/PostData/Rescuepetdatastateful.dart';

class MyRescues extends StatelessWidget {
  final MyRescueController controller = Get.put(MyRescueController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              width: width,
              height: height * 0.1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffED6D4E),
                    Color(0xffF1A852),
                  ],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "MyRescue",
                  style: GoogleFonts.encodeSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.rescueList.isEmpty) {
            return Center(child: Text('No rescues found.'));
          } else {
            return ListView.builder(
              itemCount: controller.rescueList.length,
              itemBuilder: (context, index) {
                var rescue = controller.rescueList[index];
                List<String> images =
                    (rescue['images'] ?? '').split(','); // Handle null safely
                String status =
                    (rescue['status'] ?? 0) == 2 ? 'Completed' : 'In Progress';
                return ServiceCard(
                  imageUrl:
                      'https://app.wingsandtails.in/server/rescue/addRescue.php${images[0]}',
                  status: status,
                  username: rescue['username'] ?? 'Unknown',
                  ngoName:
                      rescue['task_assigned_to'] ?? 'Not assigned', // Fallback
                );
              },
            );
          }
        }),
        bottomNavigationBar: SizedBox(
          width: 320,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => RescuePetsPage());
              },
              child: Text(
                'Rescue Pet',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffED6D4E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
