import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wat/View/Profile/MyPetadddata.dart';
import '../../Controller/Profile/MyPetsController.dart';
import 'AddPets.dart';
import 'Mypetdetail.dart'; 

class Mypets extends StatelessWidget {
  final PetController petsController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("My Pets"),
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
        body: Obx(() {
          if (petsController.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: petsController.pets.length,
                  itemBuilder: (context, index) {
                    final pet = petsController.pets[index];
      
                    return PetServices(
                      imageUrl: 'https://app.wingsandtails.in/server/mypet/uploads/${pet['petImage']}',
                      petName: pet['petName'],
                      species: pet['species_of_pet'],
                      breed: pet['breed'],
                      gender: pet['gender'],
                      dateOfBirth: pet['dob'],
                      vaccines: pet['vaccines'],
                      onTap: () {
                        final petDetail = PetDetail(
                          imageUrl: 'https://app.wingsandtails.in/server/mypet/uploads/${pet['petImage']}',
                          petName: pet['petName'],
                          species: pet['species_of_pet'],
                          breed: pet['breed'],
                          gender: pet['gender'],
                          dateOfBirth: pet['dob'],
                          detailPage: 'Detailed information about ${pet['petName']}',
                          vaccines: pet['vaccines'] ?? [],
                        );
      
                        Get.to(MyPetDetailPage(petDetail: petDetail));
                      },
                    );
                  },
                ),
              ),
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
                
                Get.to(()=>AddMyPetPage());
                
              },
              child: Text(
                'Add Pets',
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

class PetServices extends StatelessWidget {
  final String imageUrl;
  final String petName;
  final String species;
  final String breed;
  final String gender;
  final String dateOfBirth;
  final List<Map<String, String>>? vaccines;
  final VoidCallback onTap; 

  const PetServices({
    required this.imageUrl,
    required this.petName,
    required this.species,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    this.vaccines,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Species: $species',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Breed: $breed',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gender: $gender',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DOB: $dateOfBirth',
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
