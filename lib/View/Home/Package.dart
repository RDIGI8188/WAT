import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wat/View/Home/PostData/Packagedetail.dart';
import 'dart:convert';
import '../../Utils/color_constant.dart';

class PackagePage extends StatelessWidget {
  final Future<List<Package>> packages;

  PackagePage({Key? key})
      : packages = fetchPackages(),
        super(key: key);

  static Future<List<Package>> fetchPackages() async {
    final response = await http.get(Uri.parse(
        'https://app.wingsandtails.in/server/pages/package/getPackageByService.php?package_name=Grooming'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> packageList = jsonResponse['data'];
        return packageList.map((json) => Package.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load packages: ${jsonResponse['status']}');
      }
    } else {
      throw Exception('Failed to load packages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          ),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            'Grooming',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<Package>>(
          future: packages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No packages available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final package = snapshot.data![index];
                    return PackageCard(package: package);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Package {
  final int id;
  final String packageTitle;
  final String packageName;
  final String amount;
  final String? cutPrice;
  final String duration;
  final List<String> points;

  Package({
    required this.id,
    required this.packageTitle,
    required this.packageName,
    required this.amount,
    this.cutPrice,
    required this.duration,
    required this.points,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] as int,
      packageTitle: json['package_title'] as String,
      packageName: json['package_name'] as String,
      amount: '₹${json['amount']}',
      cutPrice: json['cut_price'] != null ? '₹${json['cut_price']}' : null,
      duration: json['duration'] as String,
      points: List<String>.from(json['points'] as List),
    );
  }
}

class PackageCard extends StatelessWidget {
  final Package package;

  const PackageCard({Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.packageTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Price: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                if (package.cutPrice != null)
                  Text(
                    package.cutPrice!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                SizedBox(width: 10),
                Text(
                  package.amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Duration: ${package.duration}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: package.points.isEmpty
            //       ? [Text('No description available')]
            //       : package.points
            //           .map((point) => Row(
            //                 children: [
            //                   Icon(
            //                     Icons.check_circle,
            //                     color: Colors.green,
            //                     size: 20,
            //                   ),
            //                   SizedBox(width: 8),
            //                   Expanded(
            //                     child: Text(
            //                       point,
            //                       style: TextStyle(fontSize: 14),
            //                     ),
            //                   ),
            //                 ],
            //               ))
            //           .toList(),
            // ),

            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Get.to(Packagedetail());
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       content: Text('${package.packageTitle} purchased!')),
                  // );
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorConstants.Button,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

// class PackagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xffED6D4E),
//                 Color(0xffF1A852),
//               ],
//               begin: FractionalOffset.topLeft,
//               end: FractionalOffset.bottomRight,
//             ),
//           ),
//         ),
//         leading: InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(left: 40),
//           child: Text(
//             'Grooming',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height * 1,
//         width: MediaQuery.of(context).size.width * 1,
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Get.to(Packagedetail());
//               },
//               child: PackageCard(
//                 packageName: 'Package One',
//                 price: 'Rs.1000',
//                 description: 'Basic',
//                 iconColor: Colors.green,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.to(Packagedetail());
//               },
//               child: PackageCard(
//                 packageName: 'Package Two',
//                 price: 'Rs.2000',
//                 description: 'Standard',
//                 iconColor: Colors.orange,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.to(Packagedetail());
//               },
//               child: PackageCard(
//                 packageName: 'Package Three',
//                 price: 'Rs.1500',
//                 description: 'Permium',
//                 iconColor: Colors.blue,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PackageCard extends StatelessWidget {
//   final String packageName;
//   final String price;
//   final String description;
//   final Color iconColor;

//   const PackageCard({
//     required this.packageName,
//     required this.price,
//     required this.description,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(16),
//         leading: CircleAvatar(
//           backgroundColor: iconColor,
//           child: Icon(
//             Icons.check,
//             color: Colors.white,
//           ),
//         ),
//         title: Text(
//           packageName,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(description),
//         trailing: Row(
//           mainAxisSize:
//               MainAxisSize.min, // Ensures trailing widgets take minimal space
//           children: [
//             Text(
//               price,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(
//                 width: 8), // Adds some spacing between the price and the icon
//             Icon(
//               Icons.arrow_forward_ios, // Adds the forward arrow icon
//               color: Colors.black,
//               size: 15,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
