import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';

class ByCoinsWithQRScreen extends StatefulWidget {
  const ByCoinsWithQRScreen({super.key});

  @override
  _ByCoinsWithQRScreenState createState() => _ByCoinsWithQRScreenState();
}

class _ByCoinsWithQRScreenState extends State<ByCoinsWithQRScreen> {
  final TextEditingController _coinsController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const String upiID ="realtwist@axl";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('Buy Coin'),
      ),
      body: ScaffoldBGImg(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Please make sure that after you make your payment, you will verify the payment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Image.asset("assets/spin2.png", height: 150,),
              GestureDetector(
                onTap: (){},
                child: Container(
                  height: 50,
                  width: 200,
                  margin: const EdgeInsets.only(top: 16,bottom: 16),
                  decoration: BoxDecoration(color: Colors.pink.shade400,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 5, color: Colors.white54)
                  ),
                  child: const Center(
                      child: Text(
                        "Download QR",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Clipboard.setData(const ClipboardData(text: upiID)).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("UPI ID copied"),
                      ),
                    );
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "UPI ID : ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "realtwist@axl",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    SizedBox(width: 8),
                    Icon((Icons.copy))
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Verify Your Payment",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Divider(color: Colors.white, thickness: 1.5,),
              const SizedBox(height: 16),
              TextField(
                controller: _coinsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your amount.',
                    labelText: "Enter your amount."),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _upiController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.payment),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: "Payment ID",
                    labelText: "Payment ID"),
              ),
              const SizedBox(height: 10),
              const Text(
                "We need your UPI id to send you payment",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: _sellCoins,
                  child: const Center(
                    child: Text(
                      'Sell',
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

  @override
  void dispose() {
    super.dispose();
  }

  void _sellCoins() {
    String coinsText = _coinsController.text.trim();
    String upiText = _upiController.text.trim();

    if (coinsText.isNotEmpty && upiText.isNotEmpty) {
      int numberOfCoins = int.tryParse(coinsText) ?? 0;
      if (numberOfCoins > 99) {
        _buyCoinsApiCall(numberOfCoins, upiText);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimum coin should be 100'),
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

  void _buyCoinsApiCall(int coins, String upiId) async {
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl + Api.sellCoins;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({'coins': coins, 'upiId': upiId}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Your request is in Progress. You will get update within 24 hours.'),
        ),
      );
    } else {
      // API call failed, show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to make API call. Please try again.'),
        ),
      );
    }
  }
}
