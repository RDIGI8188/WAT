import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EWalletPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {"name": "Grooming", "type": "Debit", "amount": 100},
    {"name": "Invite", "type": "Credit", "amount": 200},
    {"name": "Training", "type": "Debit", "amount": 150},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Wallet',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                      stops: [0.0, 1.0],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/wallet.png"),
                      ),
                      SizedBox(height: 10),
                      // Total Balance
                      Text(
                        "Total Balance",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "₹ 2,000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Recharge Button
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffED6D4E), Color(0xffF1A852)],
                      stops: [0.0, 1.0],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparent button
                      shadowColor: Colors.transparent, // Remove shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Redeem",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Transaction Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        // leading: Icon(
                        //   transaction["type"] == "Credit"
                        //       ? Icons.arrow_downward
                        //       : Icons.arrow_upward,
                        //   color: transaction["type"] == "Credit"
                        //       ? Colors.green
                        //       : Colors.red,
                        // ),
                        title: Text(
                          transaction["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          transaction["type"],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: transaction["type"] == "Credit"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        trailing: Text(
                          "₹ ${transaction["amount"]}",
                          style: TextStyle(
                            fontSize: 18,
                            color: transaction["type"] == "Credit"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
