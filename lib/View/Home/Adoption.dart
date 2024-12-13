

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Controller/Home/adoption_controller.dart';
import '../../Model/pet.dart';
import 'Details/Adopt.dart';
import 'Details/Adoptiodeatil.dart';

class Adoption extends StatelessWidget {
  final AdoptionController controller = Get.put(AdoptionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffED6D4E),
                    Color(0xffF1A852),
                  ],
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
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 100, right: 20),
                      child: Text(
                        "Adoption",
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
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: controller.pets.length,
              itemBuilder: (context, index) {
                final pet = controller.pets[index];
                final imageUrl = pet.images != null
                    ? 'https://app.wingsandtails.in/server/adoption/${pet.images!.split(',')[0]}'
                    : 'https://via.placeholder.com/150';

                return ServiceCard(
                  imageUrl: imageUrl,
                  pet: pet,
                );
              },
            );
          }
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              Get.to(AddPetDetailPagesss());
            },
            child: Text(
              'Upload Your Pets',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffED6D4E),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String imageUrl;
  final Pet pet;

  const ServiceCard({
    Key? key,
    required this.imageUrl,
    required this.pet,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isFavorite = false;

  Future<void> toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite; 
    });

    final url = 'https://app.wingsandtails.in/server/myFavorite/addFavorite.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': '1', 
          'petId': widget.pet.id.toString(), 
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] != 'success') {
        setState(() {
          isFavorite = !isFavorite; 
        });
        Get.snackbar('Error', 'Failed to mark as favorite',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      setState(() {
        isFavorite = !isFavorite; 
      });
      Get.snackbar('Error', 'Failed to mark as favorite',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: InkWell(
        onTap: () {
          Get.to(() => AdoptionDetailPage(pet: widget.pet)); 
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                widget.pet.customerAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pet.petDetail,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Breed: ${widget.pet.breed}'), 
                        Text('Gender: ${widget.pet.gender}'), 
                        Text('Age: ${widget.pet.age}'), 
                        Text('Color: ${widget.pet.color}'), 
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                          },
                          child: Text('Adopt Now', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffED6D4E),
                            minimumSize: Size(double.infinity, 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: toggleFavorite, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
