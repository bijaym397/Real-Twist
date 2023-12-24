import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:real_twist/payments/webview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../auth/login.dart';
import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';

class BuyCoinPU extends StatefulWidget {
  const BuyCoinPU({Key? key}) : super(key: key);

  @override
  State<BuyCoinPU> createState() => _BuyCoinPUState();
}

class _BuyCoinPUState extends State<BuyCoinPU> {
  final TextEditingController _coinsController = TextEditingController();
  final TextEditingController _transactionID = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void _sellCoins() {
    String buyMoneyText = _coinsController.text.trim();
    String transactionIDText = _transactionID.text.trim();
    if (buyMoneyText.isNotEmpty) {
      int numberOfCoins = int.tryParse(buyMoneyText) ?? 0;
      if (numberOfCoins > 9 && transactionIDText.length > 4) {
        _buyCoinsApiCall(numberOfCoins, transactionIDText);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Enter the Amount OR 'Transaction ID'"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please do not leave any field empty'),
        ),
      );
    }
  }

  void _buyCoinsApiCall(numberOfCoins, transactionIDText) async {
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl + Api.sellCoins;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({
        "amount": numberOfCoins,
        "transactionId": transactionIDText,
        "paymentType": "deposit"
      }),
    );

    if (response.statusCode == 200) {
      print("response.body ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Your request is in Progress. You will get update within 24 hours.')),
      );
      Navigator.pop(context);
    } else {
      // API call failed, show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to make API call. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text("Real Twist Buy Coin!"),
      ),
      body: ScaffoldBGImg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Pay & buy the RT coin.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          "https://pmny.in/AIPlns6BskBN",
                          title: "Buy RT Coin",
                          onPageFinished: (String url) {},
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Pay & Buy RT Coin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              const Text(
                'Verify You Payment',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please verify your payment. After the verification process, you will get your 'Coin' in your wallet!",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _coinsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_exchange),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter number amount',
                    labelText: "Enter number amount"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _transactionID,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.repeat_one),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Transaction ID',
                    labelText: "Enter Transaction ID"),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: _sellCoins,
                  child: const Center(
                    child: Text(
                      'Verify',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
