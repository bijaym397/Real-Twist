import 'package:flutter/material.dart';

import 'auth/login.dart';

class BonusChart extends StatelessWidget {
  const BonusChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade800,
          centerTitle: true,
          title: const Text('Real Twist'),
        ),
        backgroundColor: Colors.black,
        body: ScaffoldBGImg(
          child: ListView(
            children: [

              /// "phoneNumber": "7700070171",
              //     "password": guru77000
              Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16, left: 12),
                        child: Text(
                          "INVESTMENT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Container(height: 32, color: Colors.white, width: 1),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "GIFT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

              /// List
              textWidgets(text1: "70K SELF INVEST", text2: "SMART PHONE"),
              textWidgets(text1: "1.5 LAKH SELF + TEAM INVEST", text2: "LAPTOP + 10 K"),
              textWidgets(text1: "5 LAKH SELF + TEAM INVEST", text2: "IPHONE"),
              textWidgets(text1: "7 LAKH SELF + TEAM INVEST", text2: "ACTIVA"),
              textWidgets(text1: "10 LAKH SELF + TEAM INVEST", text2: "BIKE"),
              textWidgets(text1: "50 LAKH SELF + TEAM INVEST", text2: "SWIFT CAR"),
              const SizedBox(height: 84),
              const Text(
                "More offers coming soon!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
            ],
          ),
        ));
  }

  Widget textWidgets({String? text1, text2}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.white))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 12),
              child: Text(
                text1 ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
            ),
          ),
          Container(height: 32, color: Colors.white, width: 1),
          Expanded(
            flex: 2,
            child: Text(
              text2 ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
