import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../Controller/Updates/Booking.dart';

class BookingPage extends StatelessWidget {
  final BookingController bookingController = Get.put(BookingController());

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'pets':
        return Icons.pets;
      case 'pets_rounded':
        return Icons.pets_rounded;
      case 'info':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              width: width,
              height: height * 0.1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Center(
                child: Text(
                  "My Booking",
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount:
                bookingController.bookings.length - 1, // Exclude the last card
            itemBuilder: (context, index) {
              final booking = bookingController.bookings[index];
              return Column(
                children: [
                  Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            getIcon(booking['icon']!),
                            color: Colors.blue,
                            size: 30,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                booking['description']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              booking['validity']!.isNotEmpty
                                  ? Text(
                                      'Validity: ${booking['validity']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index != bookingController.bookings.length - 2)
                    Divider(thickness: 2), // Adjusted for the new item count
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
