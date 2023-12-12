import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';

class WithdrawalRequest extends StatelessWidget {
  const WithdrawalRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text("Withdrawal Request"),
      ),
      body: const ScaffoldBGImg(
        child: Center(
            child: Text("No History available",
                style: TextStyle(color: Colors.white, fontSize: 22))),
      ),
    );
  }
}
