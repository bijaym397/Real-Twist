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

  String _sessionId = "";

  @override
  void dispose() {
    _sessionId = "";
    super.dispose();
  }

  void _buyCoins() {
    String coinsText = _coinsController.text.trim();

    if (coinsText.isNotEmpty) {
      int numberOfCoins = int.tryParse(coinsText) ?? 0;
      if (numberOfCoins >= 100) {
        _buyCoinsApiCall(numberOfCoins);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter coins greater than 100'),
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

  void _buyCoinsApiCall(int coins) async {
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl + Api.payment;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({
        'buyCoin': coins,
        'success_url':
            "https://doc-hosting.flycricket.io/payment-success/b2f985b0-1c1c-41ea-acab-00918d78222f/other",
        'cancel_url':
            "https://doc-hosting.flycricket.io/payment-failed/e97a1953-99ce-42d1-bfb7-db7383cafb62/other",
      }),
    );

    if (response.statusCode == 200) {
      // API call successful, parse the response
      // Assuming response is in JSON format
      Map<String, dynamic> data = json.decode(response.body);
      String paymentUrl = data['data']['url'];
      _sessionId = data['data']['id'];

      _openWebView(paymentUrl, "Buy Coins");
    } else {
      // API call failed, show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to make API call. Please try again.'),
        ),
      );
    }
  }

  Future<bool> _updatePaymentStatus() async {
    final pref = await SharedPreferences.getInstance();

    const apiUrl = Api.baseUrl + Api.updatePaymentStatus;
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
      body: jsonEncode({
        'sessionId': _sessionId,
      }),
    );

    _sessionId = "";
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _openWebView(String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url,
          title: title,
          onPageFinished: (String url) {
            controlScreenNavigation(url);
          },
        ),
      ),
    );
  }

  void controlScreenNavigation(String url) async {
    if (url.contains("payment-success")) {
      if (await _updatePaymentStatus()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Done successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some Error while making payment.'),
          ),
        );
      }
      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
    } else if (url.contains("payment-failed")) {
      await _updatePaymentStatus();
      // API call failed, show error message using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some Error while making payment.'),
        ),
      );
      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
    }
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
                  prefixIcon: Icon(Icons.currency_exchange),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(),
                  hintText: 'Enter number of coins',
                  labelText: "Enter number of coins"),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: CommonCard(
                onTap: _buyCoins,
                child: const Center(
                  child: Text(
                    'Buy',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
