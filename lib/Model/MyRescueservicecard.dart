import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String username;
  final String ngoName;

  const ServiceCard({
    Key? key,
    required this.imageUrl,
    required this.status,
    required this.username,
    required this.ngoName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = (status == 'Completed') ? Colors.green : Colors.orange;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey,
                  child: Icon(Icons.error),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Status: $status',
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold), 
                    ),
                    Text('$ngoName'),
                    
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
