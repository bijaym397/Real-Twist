import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/home.dart';
import 'package:real_twist/main.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/modals/change_password_modal.dart';


class ChangePassword extends StatefulWidget {
  final String? token;
  const ChangePassword({Key? key, this.token}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final GlobalKey<FormState> changePasswordFormkey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

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
        child: Form(
          key: changePasswordFormkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 150),
              const Center(
                  child: Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                  )),
              const SizedBox(height: 100),
              TextFormField(
                focusNode: passwordNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "*Required";
                  if (value.length < 8) {
                    return "Password must contain at least 8 characters.";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  prefixIcon: const Icon(Icons.key),
                  border: const OutlineInputBorder(),
                  hintText: 'Enter New Password',
                  labelText: "Enter New Password",
                  suffixIcon: InkWell(
                    onTap: (){
                      hidePassword = !hidePassword;
                      setState(() {

                      });
                    },
                    child: Icon(
                      hidePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    /*onTap: () {

                            }*/
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: confirmPasswordNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: hideConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (value.length < 8) {
                    return "Minimum length is 8";
                  } else if (passwordController.value.text !=
                      confirmPasswordController.value.text) {
                    return "Password & Confirmation password do not match";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Confirm Password',
                  labelText: "Enter Confirm Password",
                  suffixIcon: InkWell(
                    onTap: (){
                      hideConfirmPassword = !hideConfirmPassword;
                      setState(() {

                      });
                    },
                    child: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    /*onTap: () {

                          }*/
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: () {
                    if (changePasswordFormkey.currentState!.validate()) {
                      _hitChangePasswordApi(
                        password: passwordController.text.trim(),
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

  Future<void> _hitChangePasswordApi(
      {String? password}) async {
    try {
      debugPrint("toeknt ${widget.token.toString()}");
      customLoader!.show(context);
      const apiUrl = "${Api.baseUrl}${Api.changePassword}";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': widget.token.toString(),
          'password': password.toString(),
        }),
      );
      debugPrint("requested data ${jsonEncode({
        'token': widget.token.toString(),
        'password': password.toString(),
      }).toString()}");
      final changePassData = ChangePasswordApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password Changed ${changePassData.message}"),
        ));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),(Route<dynamic> route) => false);
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${changePassData.message}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint("errors ${e.toString()}");
    }
  }

}
