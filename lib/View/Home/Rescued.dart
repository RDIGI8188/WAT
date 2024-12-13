import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/Home/RescuedController.dart';
import 'Details/RescuedDetailPage.dart';
import 'PostData/Rescuepetdatastateful.dart';

class RescueList extends StatelessWidget {
  final RescuedControllers controller = Get.put(RescuedControllers()); 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Rescued",
                        style: GoogleFonts.encodeSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage.value}'));
          } else if (controller.rescues.isEmpty) {
            return const Center(child: Text('No rescues found.'));
          }

          return ListView.builder(
            itemCount: controller.rescues.length,
            itemBuilder: (context, index) {
              final rescue = controller.rescues[index];
              return ServiceCard(
                imageUrl: rescue.images.isNotEmpty ? rescue.images[0] : '',
                status: rescue.status == '1' ? 'In Progress' : 'Completed',
                username: rescue.username,
                ngoName: rescue.taskAssignedTo,
                rescue: rescue,
              );
            },
          );
        }),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                Get.to(RescuePetsPage());
              },
              child: Text(
                'Request Rescue',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffED6D4E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String username;
  final String ngoName;
  final Rescue rescue; 

   ServiceCard({
    Key? key,
    required this.imageUrl,
    required this.status,
    required this.username,
    required this.ngoName,
    required this.rescue, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            Get.to(RescueDetailPage(rescue: rescue));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        color: status == 'Completed' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ngoName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
