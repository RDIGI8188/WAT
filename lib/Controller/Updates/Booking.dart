import 'package:get/get.dart';

class BookingController extends GetxController {
  final List<Map<String, String>> bookings = [
    {
      'title': 'Grooming',
      'description': 'Premium Package - Active',
      'validity': '12 Dec 2024',
      'icon': 'card_giftcard',
    },
    {
      'title': 'Dog Walking',
      'description': 'Premium Package - Active',
      'validity': '25 Dec 2024',
      'icon': 'pets',
    },
    {
      'title': 'Training',
      'description': 'Premium Package - Active',
      'validity': '10 June 2025',
      'icon': 'pets_rounded',
    },
    {
      'title': 'Additional Info',
      'description': 'Manage your package and here',
      'validity': '',
      'icon': 'info',
    },
  ];
}
