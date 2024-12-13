import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Model/pet.dart';

class AdoptionDetailPage extends StatelessWidget {
  final Pet pet;

  const AdoptionDetailPage({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _images = pet.images != null
        ? pet.images!.split(',').map((img) => 'https://app.wingsandtails.in/server/adoption/$img').toList()
        : [];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Container(
                  height: 300,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 20,
                        left: 16,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_images.length, (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard('Breed', pet.reason),
                        _infoCard('Age', pet.age != null ? pet.age.toString() : 'Unknown'), 
                        _infoCard('Color', pet.color ?? 'Unknown'), 
                        _infoCard('Sex', pet.gender ?? 'Unknown'), 
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Location: ${pet.customerAddress}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Text(
                      pet.petDetail,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      pet.customerAddress,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),

                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This pet needs a loving home. For more details, contact us.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Adopt Now',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adoption Confirmation'),
          content: Text('Are you sure you want to adopt this pet?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.snackbar("Adoption", "Thank you for adopting this pet!");
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('No', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
