import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/main.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/modals/coins_modal.dart';
import 'package:real_twist/modals/coins_request_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/strings.dart';
import '../home.dart';

class SetAppVersion extends StatefulWidget {
  const SetAppVersion({Key? key}) : super(key: key);

  @override
  State<SetAppVersion> createState() => _SetAppVersionState();
}

class _SetAppVersionState extends State<SetAppVersion> {
  final GlobalKey<FormState> versionFormKey = GlobalKey<FormState>();
  TextEditingController versionController = TextEditingController();
  FocusNode versionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.pink.shade800,
        title: const Text("Set App Version"),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black,
      body: ScaffoldBGImg(
        child: Form(
          key: versionFormKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 150),
              const Center(
                  child: Text(
                    "Set App Version",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                  )),
              const SizedBox(height: 100),
              TextFormField(
                focusNode: versionNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: versionController,
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
                  prefixIcon: Icon(Icons.cached),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Version',
                  labelText: "Enter Version",
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: () {
                    if (versionFormKey.currentState!.validate()) {
                      _hitVersionApi(
                        setVersion: versionController.text.trim(),
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

  Future<void> _hitVersionApi({String? setVersion}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "${Api.baseUrl}${Api.setVersion}";
      final pref = await SharedPreferences.getInstance();

      final Map<String, dynamic> requestMap = {
        "type": "appversion",
        "setting": {
          "version": setVersion.toString() ?? "1.0.0"
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
          content: Text("Version set ${data['data']['setting']['version'] ?? "1.0.0"}"),
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
