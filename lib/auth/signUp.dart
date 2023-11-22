import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/auth/widgets.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/modals/sign_up_model.dart';
import 'package:real_twist/utils/Back_handler.dart';
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

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BackHandler(
      child: Scaffold(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      counterText: "",
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Password',
                      labelText: "Enter Your Password",
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
                      hintText: 'Enter Your Confirm Password',
                      labelText: "Enter Your Confirm Password",
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
                const SizedBox(height: 24),
                ButtonCommon(
                  title: "Submit",
                  onTap: () {
                    debugPrint(confirmPasswordController.value.text);
                    if (signUpFormKey.currentState!.validate()) {
                      _hitSignUpApi(
                          name: nameController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          password: passwordController.text.trim()
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                BottomText(
                  text: "Already have an account?",
                  text2: " Log in",
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginView()),(Route<dynamic> route) => false);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _hitSignUpApi(
      {String? name, String? phoneNumber, String? password,}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "${Api.baseUrl}${Api.signup}";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name.toString(),
          'phoneNumber': phoneNumber.toString(),
          'countryCode': "+91",
          'password': password.toString(),
        }),
      );
      final signUpData = SignUpResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${signUpData.message}"),
        ));
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        // sharedPreferences.setBool("isEntered", isEntered = true);
        // Navigate to OTP verification screen
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(phoneNumber: signUpData.data!.phoneNumber.toString() ?? "000000",
              verificationCode: signUpData.data!.verificationCode.toString() ?? "0000",
            userId: signUpData.data!.sId.toString() ?? "0000",
            ),
          ),
        ).then((value) =>
        {
          sharedPreferences.setString(
              AppStrings.spId, signUpData.data!.sId.toString()),
          sharedPreferences.setString(
              AppStrings.spCode, signUpData.data!.verificationCode.toString()),
        });
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${signUpData.message}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint(e.toString());
    }
  }
}
