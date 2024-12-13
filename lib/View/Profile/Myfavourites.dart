import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ignore: unused_import
import '../../Utils/color_constant.dart';

class FavoritePetController extends GetxController {
  var favoritePets = <Map<String, dynamic>>[].obs;
  var likedPets = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoritePets();
  } 

  Future<void> fetchFavoritePets() async {
    final url =
        'https://app.wingsandtails.in/server/myFavorite/getFavorite.php?userId=92';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Pet details fetched successfully.') {
          List pets = data['petDetails'];
          favoritePets.value = pets.map((pet) {
            return {
              'imageUrl': pet['petImage'],
              'petName': pet['petName'],
              'petBreed': pet['breed'],
              'gender': pet['gender'],
              'dob': pet['dob'],
              'neutral': pet['neutral'],
              'vaccinated': pet['vaccinated'],
              'location': 'Unknown',
            };
          }).toList();
        }
      } else {
        print("Failed to fetch favorites.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void toggleLike(String petName) {
    if (likedPets.contains(petName)) {
      likedPets.remove(petName);
    } else {
      likedPets.add(petName);
    }
  }

  bool isLiked(String petName) {
    return likedPets.contains(petName);
  }
}

class MyFavourite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoritePetController controller = Get.put(FavoritePetController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios)),
          title: Text(
            'My Favourites',
            style: TextStyle(color: Colors.white),
          ),
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
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.favoritePets.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: controller.favoritePets.length,
            itemBuilder: (context, index) {
              final pet = controller.favoritePets[index];
              return FavoritePetCard(
                imageUrl: pet['imageUrl'] ?? '',
                petName: pet['petName'] ?? '',
                petBreed: pet['petBreed'] ?? '',
                gender: pet['gender'] ?? '',
                dob: pet['dob'] ?? '',
                neutral: pet['neutral'] ?? 0,
                vaccinated: pet['vaccinated'] ?? 0,
                location: pet['location'] ?? 'Unknown',
              );
            },
          );
        }),
      ),
    );
  }
}

class FavoritePetCard extends StatelessWidget {
  final String imageUrl;
  final String petName;
  final String petBreed;
  final String gender;
  final String dob;
  final int neutral;
  final int vaccinated;
  final String location;

  const FavoritePetCard({
    required this.imageUrl,
    required this.petName,
    required this.petBreed,
    required this.gender,
    required this.dob,
    required this.neutral,
    required this.vaccinated,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritePetController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 120,
                          width: 120,
                          child: Image.network(
                            imageUrl,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Text(
                        petName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Breed: $petBreed',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Gender: $gender',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'DOB: $dob',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Vaccinated: ${vaccinated == 1 ? "Yes" : "No"}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Neutral: ${neutral == 1 ? "Yes" : "No"}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return IconButton(
                    icon: Icon(
                      controller.isLiked(petName)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: controller.isLiked(petName)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      controller.toggleLike(petName);
                    },
                  );
                }),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Adopt"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
