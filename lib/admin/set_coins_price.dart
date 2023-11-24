import 'package:flutter/material.dart';

import '../home.dart';

class SetCoinPrice extends StatefulWidget {
  const SetCoinPrice({Key? key}) : super(key: key);

  @override
  State<SetCoinPrice> createState() => _SetCoinPriceState();
}

class _SetCoinPriceState extends State<SetCoinPrice> {
  final GlobalKey<FormState> setCoinFormKey = GlobalKey<FormState>();
  TextEditingController setCoinCont = TextEditingController();
  FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.pink.shade800,
        title: const Text("My Profile"),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black87,

    );
  }
}
