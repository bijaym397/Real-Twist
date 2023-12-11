import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/main.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/modals/coins_modal.dart';
import 'package:real_twist/modals/coins_request_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/strings.dart';
import '../home.dart';

class SetCoinPrice extends StatefulWidget {
  const SetCoinPrice({Key? key}) : super(key: key);

  @override
  State<SetCoinPrice> createState() => _SetCoinPriceState();
}

class _SetCoinPriceState extends State<SetCoinPrice> {
  final GlobalKey<FormState> setCoinFormKey = GlobalKey<FormState>();
  TextEditingController setCoinController = TextEditingController();
  FocusNode setCoinNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.pink.shade800,
        title: const Text("Set Coins Price"),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: setCoinFormKey,
          child: ListView(
            children: [
              const SizedBox(height: 150),
              const Center(
                  child: Text(
                    "Set Coins",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                  )),
              const SizedBox(height: 100),
              TextFormField(
                focusNode: setCoinNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: setCoinController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    {return "*Required";}
                  return null;
                },
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  prefixIcon: Icon(Icons.change_circle_outlined),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Coins',
                  labelText: "Enter Coins",
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: () {
                    if (setCoinFormKey.currentState!.validate()) {
                      _hitSetCoinsApi(
                        setCoins: setCoinController.text.trim(),
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Submit',
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

  Future<void> _hitSetCoinsApi({String? setCoins}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "${Api.baseUrl}${Api.setCoinsPrice}";
      final pref = await SharedPreferences.getInstance();

      final Map<String, dynamic> requestMap = {
        "type": "coinprice",
        "setting": {
          "price": int.tryParse(setCoins.toString()) ?? 1
        },
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': pref.getString(AppStrings.spAuthToken) ?? "",
        },
        body: json.encode(requestMap),
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Coins set ${data['data']['setting']['price'] ?? 0}"),
        ));
        Navigator.pop(context,{"refresh": true});
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const LoginView()),(Route<dynamic> route) => false);
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${data['message']}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint("errors ${e.toString()}");
    }
  }

}
