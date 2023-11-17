import 'package:flutter/material.dart';
import 'package:real_twist/login.dart';
import 'package:real_twist/otp.dart';
import 'package:real_twist/otp_verification_screen.dart';
import 'package:real_twist/utils/form_validator.dart';

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
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              )),
              const SizedBox(height: 40),
              TextFormField(
                focusNode: nameNode,
                controller: nameController,
                validator: FromValidator.phoneValidator,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
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
                validator: FromValidator.phoneValidator,
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
                validator: FromValidator.emailValidator,
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
                validator: FromValidator.passwordValidator,
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
                  if (value == null || value.isEmpty) return "*Required";
                  if (value.length < 8) return "Minimum length is 8";
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
              const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18),),
                  onPressed: () {
                    if(signUpFormKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtpVerificationScreen(phoneNumber: '9088099176'),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "You don't have a account, ",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
