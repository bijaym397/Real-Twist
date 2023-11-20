import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/auth/widgets.dart';
import 'package:real_twist/utils/form_validator.dart';

import 'otp_verification_screen.dart';

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
                  if (value == null || value.trim().isEmpty) {
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
                  if (value == null || value.trim().isEmpty) {
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
                        builder: (context) => const OtpVerificationScreen(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
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
}
