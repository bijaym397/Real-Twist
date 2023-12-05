import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:real_twist/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/main.dart';
import 'package:real_twist/utils/dateFormater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';

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
    const apiUrl = Api.baseUrl + Api.spinCoinHistory;
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
        final List<dynamic> spinCoinData = responseData['data'];

        setState(() {
          spinCoins = spinCoinData.cast<Map<String, dynamic>>();
        });
        customLoader!.hide();
      } else {
        // Handle API error
        print('Failed to fetch payment history}');
        customLoader!.hide();
      }
    } catch (e) {
      debugPrint("$e");
      customLoader!.hide();
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
      body: spinCoins.isEmpty
          ? const Center(
              child: Text("No History available",
                  style: TextStyle(color: Colors.white, fontSize: 22)))
          : ListView.builder(
        padding: EdgeInsets.all(16),
              itemCount: spinCoins.length,
              itemBuilder: (context, index) {
                final coins = spinCoins[index];
                // Extracting data from the payment object
                final paymentId = coins['_id'];
                final winCoin = coins['winCoin'];
                final winNumber = coins['winNumber'];
                final createdAt = coins['createdAt'];
                final type = coins['type'];

                // Determine the color based on the status
                Color statusColor = Colors.grey;
                // if (status == 'succeeded') {
                //   statusColor = Colors.green;
                // } else if (status == 'failed') {
                //   statusColor = Colors.red;
                // }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CommonCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment ID:   $paymentId",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            "Win Coin:   $winCoin",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Date:   ${formatDate(createdAt).toString()}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Win Number:   $winNumber",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Type:   $type",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                );
              },
            ),
    );
  }
}
