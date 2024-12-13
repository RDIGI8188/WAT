import 'package:flutter/material.dart';
import 'package:wat/Controller/Home/RescuedController.dart';

class RescueDetailPage extends StatelessWidget {
  final Rescue rescue;

  const RescueDetailPage({Key? key, required this.rescue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                child: PageView.builder(
                  itemCount: rescue.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      rescue.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.error)),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rescue: ${rescue.status == '1' ? 'In Progress' : 'Completed'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            rescue.status == '1' ? Colors.orange : Colors.green,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'person: ${rescue.location}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Location: ${rescue.address}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Assigned to: ${rescue.taskAssignedTo}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Reported at: ${rescue.currentTimestamp}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20),
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
