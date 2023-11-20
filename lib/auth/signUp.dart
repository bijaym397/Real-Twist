import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/auth/widgets.dart';
import 'package:real_twist/utils/form_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/strings.dart';
import '../main.dart';
import '../modals/login_data_modal.dart';
import 'otp_verification_screen.dart';
import 'package:http/http.dart' as http;

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: signUpFormKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Please Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                focusNode: nameNode,
                controller: nameController,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return "*Required";
                  } else if (value.length < 3) {
                    return "Name should be 3 characters";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_2_outlined),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Full Name',
                    labelText: "Enter Your Full Name"),
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: phoneNode,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return "*Required";
                  } else if (value.length < 10) {
                    return "Number should be 10 characters";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Phone Number',
                    labelText: "Enter Your Phone Number"),
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: emailNode,
                controller: emailController,
                validator: validateEmail,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Email iD',
                    labelText: "Enter Your Email iD"),
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: passwordNode,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Required";
                  } else if (value.length < 8) {
                    return "Minimum length is 8";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Password',
                    labelText: "Enter Your Password"),
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: confirmPasswordNode,
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
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
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Confirm Password',
                    labelText: "Enter Your Confirm Password"),
              ),
              const SizedBox(height: 24),
              ButtonCommon(
                title: "Submit",
                onTap: () {
                  print(confirmPasswordController.value.text);
                  if (signUpFormKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const OtpVerificationScreen(
                            phoneNumber: '9088099176'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
              BottomText(
                text: "Already have an account?",
                text2: " Log in",
                onTap: () {
                  if (signUpFormKey.currentState!.validate()) {
                    _hitSignUpApi(
                      name: nameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _hitSignUpApi(
      {String? name, String? phoneNumber, String? email, String? password,}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "http://178.16.138.186:6000/api/login";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // 'phoneNumber': phone.toString(),
          // 'countryCode': countryCode.toString(),
          // 'password': password.toString(),

          'phoneNumber': "7452823763",
          'countryCode': "+91",
          'password': "Bhandari@123",
        }),
      );
      final loginData = LoginData.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login ${loginData.message}"),
        ));
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        // sharedPreferences.setBool("isEntered", isEntered = true);
        // Navigate to OTP verification screen
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpVerificationScreen(phoneNumber: "7452823763"),
          ),
        ).then((value) =>
        {
          sharedPreferences.setString(
              AppStrings.spUserId, loginData.data!.userId.toString()),
          sharedPreferences.setString(
              AppStrings.spAuthToken, loginData.data!.userId.toString()),
        });
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${loginData.message}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint(e.toString());
    }
  }
}
