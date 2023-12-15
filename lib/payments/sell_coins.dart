import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';

class SellCoinsScreen extends StatefulWidget {
  const SellCoinsScreen({super.key});

  @override
  _SellCoinsScreenState createState() => _SellCoinsScreenState();
}

class _SellCoinsScreenState extends State<SellCoinsScreen> {
  final TextEditingController _coinsController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

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
        _buyCoinsApiCall(numberOfCoins,upiText);
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

  void _buyCoinsApiCall(int coins,String upiId) async{
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl+Api.sellCoins;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({
        'coins': coins,
        'upiId': upiId
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your request is in Progress. You will get update within 24 hours.'),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('Sell Coins'),
      ),
      body: ScaffoldBGImg(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _coinsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter number of coins',
                    labelText: "Enter number of coins"
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _upiController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.payment),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Your UPI id',
                    labelText: "Your UPI id"
                ),
              ),
              const SizedBox(height: 10),
              const Text("We need your UPI id to send you payment", style: TextStyle(
                color: Colors.white54
              ),),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap:_sellCoins,
                  child: const Center(
                    child: Text(
                      'Sell',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
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