import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/utils/dateFormater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import '../main.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late List<Map<String, dynamic>> payments = [];

  @override
  void initState() {
    super.initState();
    fetchAdminPaymentHistory();
  }

  Future<void> fetchAdminPaymentHistory() async {
    final pref = await SharedPreferences.getInstance();
    const apiUrl = Api.baseUrl + Api.adminPaymentHistory;
    try {
      customLoader!.show(context);
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': pref.getString(AppStrings.spAuthToken) ?? "",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> paymentsData = responseData['data'];

        setState(() {
          payments = paymentsData.cast<Map<String, dynamic>>();
        });
        customLoader!.hide();
      } else {
        // Handle API error
        debugPrint('Failed to fetch payment history}');
        customLoader!.hide();
      }
    } catch (e) {
      debugPrint("$e");
      customLoader!.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    const String img = "assets/user.png";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text("Payment History"),
      ),
      body: ScaffoldBGImg(child: payments.isEmpty
          ? const Center(
          child: Text("No History available",
              style: TextStyle(color: Colors.white, fontSize: 22)))
          : ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];

          // Extracting data from the payment object
          final paymentId = payment['_id'];
          final amount = payment['amount'];
          final status = payment['status'];
          final createdAt = payment['createdAt'];
          final buyCoin = payment['buyCoin'];
          final userName = payment['users']['name'];

          // Determine the color based on the status
          Color statusColor = Colors.grey;
          if (status == 'succeeded') {
            statusColor = Colors.green;
          } else if (status == 'unpaid') {
            statusColor = Colors.red;
          }

          return Container(
            margin: const EdgeInsets.only(top: 12, right: 8, left: 8),
            child: CommonCard(
              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                      ),
                      child: Container(
                        height: 100,
                        width: 60,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            image: userName[0] == ""
                                ? const DecorationImage(image: AssetImage(img))
                                : null,
                            color: Colors.pink.shade600,
                            shape: BoxShape.circle),

                        /// Who is this
                        child: userName[0] != ""
                            ? Center(
                            child: Text(
                              userName[0].toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32),
                            ))
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: $userName",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                          'Payment ID: $paymentId',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Amount: $amount',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Coins: $buyCoin',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Date: ${formatDate(createdAt).toString()}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Status: $status',
                                style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),)
    );
  }
}
