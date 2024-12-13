import 'package:get/get.dart';

class FavoritePetController extends GetxController {
  var likedPets = <String, bool>{}.obs;

  void toggleLike(String petName) {
    if (likedPets.containsKey(petName)) {
      likedPets[petName] = !likedPets[petName]!;
    } else {
      likedPets[petName] = true;
    }
  }

  bool isLiked(String petName) {
    return likedPets[petName] ?? false;
  }
}
