import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/payments/webview_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';

class BuyCoinsScreen extends StatefulWidget {
  const BuyCoinsScreen({super.key});

  @override
  _BuyCoinsScreenState createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreen> {
  final TextEditingController _coinsController = TextEditingController();

  void _buyCoins() {
    String coinsText = _coinsController.text.trim();

    if (coinsText.isNotEmpty) {
      int numberOfCoins = int.tryParse(coinsText) ?? 0;

      if (numberOfCoins > 0) {
        _buyCoinsApiCall(numberOfCoins);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter coins greater than 0'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the number of coins'),
        ),
      );
    }
  }

  void _buyCoinsApiCall(int coins) async{
// Make API call
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl+Api.payment;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({
        'spendCoin': coins,
      }),
    );

    if (response.statusCode == 200) {
      // API call successful, parse the response
      // Assuming response is in JSON format
      Map<String, dynamic> data = json.decode(response.body);

      // Extract paymentUrl from the response
      String paymentUrl = data['paymentUrl'];

      // Open paymentUrl in WebView
      _openWebView(paymentUrl);
    } else {
      // API call failed, show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to make API call. Please try again.'),
        ),
      );
    }
  }


  void _openWebView(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url,
          onPageFinished: (String url) {
            // Check if the URL contains '/success'
            if (url.contains('/success')) {
              // Set paymentDone to true
              setState(() {
                paymentDone = true;
              });

              // Pop the WebView
              Navigator.of(context).pop();

              // Call the refresh function on the previous screen
              _refreshScreen();
            }
          },
        ),
      ),
    );
  }

  void _refreshScreen() {
    // Implement the logic to refresh the screen here
    print('Screen refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('Buy Coins'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _coinsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number of coins',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: CommonCard(
                onTap:_buyCoins,
                child: const Center(
                  child: Text(
                    'Buy',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
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