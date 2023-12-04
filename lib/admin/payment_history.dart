import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  const apiUrl = Api.baseUrl+Api.adminPaymentHistory;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'token': pref.getString(AppStrings.spAuthToken) ?? "",
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> paymentsData = responseData['data']['payments'];

    setState(() {
      payments = paymentsData.cast<Map<String, dynamic>>();
    });
  } else {
    // Handle API error
    print('Failed to fetch payment history}');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.pink.shade800,
      centerTitle: true,
      title: const Text("Payment History"),
    ),
    body: ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];

        // Extracting data from the payment object
        final paymentId = payment['_id'];
        final amount = payment['amount'];
        final status = payment['status'];
        final createdAt = payment['createdAt'];
        final buyCoin = payment['buyCoin'];

        // Formatting date
        final formattedDate = DateTime.parse(createdAt).toLocal();

        // Determine the color based on the status
        Color statusColor = Colors.grey;
        if (status == 'succeeded') {
          statusColor = Colors.green;
        } else if (status == 'failed') {
          statusColor = Colors.red;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10,top: 5),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment ID: $paymentId'),
                Text('Amount: $amount'),
                Text('Date: ${formattedDate.toString()}'),
                Text('Coins: $buyCoin'),
                Text(
                  'Status: $status',
                  style: TextStyle(color: statusColor),
                ),
              ],
            ),
            // Divider between list items
            tileColor: Colors.transparent,
          ),
        );
      },
    ),
  );
}
}
