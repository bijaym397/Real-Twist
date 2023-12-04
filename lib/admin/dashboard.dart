import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:real_twist/admin/payment_history.dart';
import 'package:real_twist/admin/set_coins_price.dart';
import 'package:real_twist/admin/spin_coin_history.dart';
import 'package:real_twist/admin/users_list_screen.dart';
import 'package:real_twist/home.dart';

import '../menu.dart';
import '../payments/payment_history.dart';
import 'get_coin_price.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

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
              Container(
                height: 200,
                child: CommonCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 68,
                        lineWidth: 15,
                        animation: true,
                        percent: 60 / 100,
                        backgroundColor: Colors.white38,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                        center: const Text("60.0%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
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
                            SizedBox(height: 6),
                            Text(
                              "450000",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color: Colors.black54),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetCoinPrice(),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Set Coin Price",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
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
                        fontSize: 30,
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
                        fontSize: 30,
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
                        fontSize: 30,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
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
                        fontSize: 30,
                        color: Colors.white.withOpacity(.7)),
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
            ],
          ),
        ));
  }
}
