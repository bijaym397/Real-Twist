import 'package:flutter/material.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: ElevatedButton(
        onPressed: () async {},
        child: const Text(
          "Payment",
          style: TextStyle(color: Colors.white),
        ),
      )),
    );
  }
}
