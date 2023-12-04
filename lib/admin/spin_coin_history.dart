import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpinCoinHistory extends StatefulWidget {

  const SpinCoinHistory({Key? key}) : super(key: key);

  @override
  State<SpinCoinHistory> createState() => _SpinCoinHistoryState();
}

class _SpinCoinHistoryState extends State<SpinCoinHistory> {
  late List<Map<String, dynamic>> spinCoins = [];
  @override
  void initState() {
    super.initState();
    fetchSpinCoinHistory();
  }

  Future<void> fetchSpinCoinHistory() async {
    final pref = await SharedPreferences.getInstance();
    const apiUrl = Api.baseUrl+Api.spinCoinHistory;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> spinCoinData = responseData['data']['payments'];

      setState(() {
        spinCoins = spinCoinData.cast<Map<String, dynamic>>();
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
        title: const Text("Spin Coin History"),
      ),
      body: ListView.builder(
        itemCount: spinCoins.length,
        itemBuilder: (context, index) {
          final coins = spinCoins[index];

          // Extracting data from the payment object
          final paymentId = coins['_id'];
          final winCoin = coins['winCoin'];
          final winNumber = coins['winNumber'];
          final createdAt = coins['createdAt'];
          final type = coins['type'];

          // Formatting date
          final formattedDate = DateTime.parse(createdAt).toLocal();

          // Determine the color based on the status
          Color statusColor = Colors.grey;
          // if (status == 'succeeded') {
          //   statusColor = Colors.green;
          // } else if (status == 'failed') {
          //   statusColor = Colors.red;
          // }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 5),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment ID: $paymentId'),
                  Text('Win Coin: $winCoin'),
                  Text('Date: ${formattedDate.toString()}'),
                  Text('Win Number: $winNumber'),
                  Text(
                    'Type: $type',
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
