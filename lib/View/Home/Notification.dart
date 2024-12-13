import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime date;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
  });
}

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    notifications.addAll([
      NotificationModel(
        title: 'New Adoption Request',
        message: 'You have a new adoption request from John Doe.',
        date: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      NotificationModel(
        title: 'Grooming Appointment',
        message:
            'Your grooming appointment is scheduled for tomorrow at 10 AM.',
        date: DateTime.now().subtract(Duration(hours: 1)),
      ),
      NotificationModel(
        title: 'Rescue Alert',
        message: 'A new rescue alert has been posted in your area.',
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
    ]);
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            'Notifications',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
          if (controller.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications available',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${_formatDate(notification.date)}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    //   Get.to(NotificationDetailPage(notification: notification));
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// class NotificationDetailPage extends StatelessWidget {
//   final NotificationModel notification;

//   const NotificationDetailPage({Key? key, required this.notification}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           notification.title,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color(0xffED6D4E),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(notification.message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Text(
//               'Received on: ${_formatDate(notification.date)}',
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xffF1A852),
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () {
//                 Get.back(); 
//               },
//               child: Text(
//                 'Back to Notifications',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//   }
// }
