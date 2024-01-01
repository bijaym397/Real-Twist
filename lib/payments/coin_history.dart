import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../auth/login.dart';
import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';
import '../main.dart';

class CoinHistory extends StatefulWidget {
  const CoinHistory({Key? key}) : super(key: key);

  @override
  State<CoinHistory> createState() => _CoinHistoryState();
}

class _CoinHistoryState extends State<CoinHistory> {
  late List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    final pref = await SharedPreferences.getInstance();
    const apiUrl = Api.baseUrl+Api.userCoinHistory;
    try{
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
        customLoader!.hide();
        setState(() {
          data = paymentsData.cast<Map<String, dynamic>>();
        });
        print("payments");
        print(data.toString());
      } else {
        // Handle API error
        print('Failed to fetch payment history}');
        customLoader!.hide();
        print("payments");
      }
    }
    catch(e){
      customLoader!.hide();
      debugPrint("$e");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade800,
          centerTitle: true,
          title: const Text("Coin History"),),
        body: ScaffoldBGImg(
      child: data.isEmpty
          ? const Center(
          child: Text("No History available",
              style: TextStyle(color: Colors.white, fontSize: 22)))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final payment = data[index];

          // Extracting data from the payment object
          final paymentId = payment['paymentId'];
          final amount = payment['coins'];
          final status = payment['status'];
          final createdAt = payment['createdAt'];
          final buyCoin = payment['type'];

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
            padding:
            const EdgeInsets.only(top: 16, right: 12, left: 12),
            child: CommonCard(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Payment ID: ${paymentId ?? ""}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
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
                    'Date: ${formattedDate.toString()}',
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
          );
          //   Padding(
          //   padding: const EdgeInsets.only(bottom: 10,top: 5),
          //   child: ListTile(
          //     title: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Payment ID: $paymentId'),
          //         Text('Amount: $amount'),
          //         Text('Date: ${formattedDate.toString()}'),
          //         Text('Coins: $buyCoin'),
          //         Text(
          //           'Status: $status',
          //           style: TextStyle(color: statusColor),
          //         ),
          //       ],
          //     ),
          //     // Divider between list items
          //     tileColor: Colors.transparent,
          //   ),
          // );
        },
      ),
    ));
  }
}
