import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:real_twist/admin/payment_history.dart';
import 'package:real_twist/admin/set_coins_price.dart';
import 'package:real_twist/admin/spin_coin_history.dart';
import 'package:real_twist/admin/users_list_screen.dart';
import 'package:real_twist/admin/withdrawal_request.dart';
import 'package:real_twist/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import '../constants/strings.dart';
import '../menu.dart';
import '../payments/payment_history.dart';
import 'package:http/http.dart' as http;

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  int totalCoins = 0;
  double percentage = 0.0;
  int coinPrice = 0;

  @override
  initState(){
   super.initState();
   _fetchDetails();
  }

  _fetchDetails() async{
    const apiUrl = Api.baseUrl+Api.dashboardDetails;
    final pref = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 200) {

        setState(() {
          totalCoins = data['data']['totalCoins'] ?? 0;
          coinPrice = data['data']['setting']['price'] ?? 0;
        });

        setState(() {
          percentage = totalCoins / 50000000 * 100;
        });
      } else {
        throw Exception('Failed to load user details');
      }
    } else {
      throw Exception('Failed to load user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            "Real Twist Admin",
          ),
          centerTitle: true,
          backgroundColor: Colors.pink.shade800,
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 200,
                child: CommonCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 68,
                        lineWidth: 15,
                        animation: true,
                        percent: percentage / 100,
                        backgroundColor: Colors.white38,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                        center: Text("${formatPercentage(percentage)}%\nRemain",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Coin available",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.white.withOpacity(.8)),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "$totalCoins",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "₹$coinPrice Per Coin Price",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Colors.white54),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Set Coin Price
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CommonCard(
                  onTap: () async{
                    final response =  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetCoinPrice(),
                      ),
                    );

                    if (response["refresh"] == true) {
                      _fetchDetails();
                    }
                  },
                  child: Center(
                      child: Text(
                    "Set Coin Price",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
                ),
              ),

              /// User Details
              Container(
                height: 120,
                padding: const EdgeInsets.only(bottom: 16),
                child: CommonCard(
                  child: Center(
                      child: Text(
                    "Users",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListScreen()));
                  },
                ),
              ),
              /// Withdrawal Request
              Container(
                height: 120,
                padding: const EdgeInsets.only(bottom: 16),
                child: CommonCard(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WithdrawalRequest()));
                  },
                  child: Center(
                      child: Text(
                        "Withdrawal Request",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Colors.white.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      )),
                ),
              ),
              /// Get Payment History
              Container(
                height: 120,
                padding: const EdgeInsets.only(bottom: 16),
                child: CommonCard(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentHistory()));
                  },
                  child: Center(
                      child: Text(
                    "Get Payment History",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              /// Get Spin Coin History
              Container(
                height: 120,
                padding: const EdgeInsets.only(bottom: 16),
                child: CommonCard(
                  child: Center(
                      child: Text(
                        "Get Spin Coin History",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Colors.white.withOpacity(.7)),
                        textAlign: TextAlign.center,
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpinCoinHistory()));
                  },
                ),
              ),

              /// Logout
              Container(
                height: 120,
                padding: const EdgeInsets.only(bottom: 16),
                child: CommonCard(
                  onTap: () {
                    showTextFieldPopup(context);
                  },
                  child: Center(
                      child: Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
            ],
          ),
        ));
  }

  String formatPercentage(double percentage) {
    String normalizedPercentage = percentage.toString();

    if (normalizedPercentage.contains('.')) {
      int indexOfDecimal = normalizedPercentage.indexOf('.');
      String decimalPart = normalizedPercentage.substring(indexOfDecimal + 1);

      if (decimalPart.length > 2) {
        normalizedPercentage = normalizedPercentage.substring(0, indexOfDecimal + 3);
      }
    }

    return normalizedPercentage;
  }
}
