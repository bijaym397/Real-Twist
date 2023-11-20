import 'package:flutter/material.dart';
import 'package:real_twist/utils/form_validator.dart';

import 'auth/widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  FocusNode oldPassword = FocusNode();
  FocusNode newPassword = FocusNode();
  FocusNode confirmNewPassword = FocusNode();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController confirmNewPasswordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text("Change Password"),
          TextFormField(
            focusNode: oldPassword,
            controller: oldPasswordCont,
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
            focusNode: newPassword,
            controller: newPasswordCont,
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
            focusNode: confirmNewPassword,
            controller: confirmNewPasswordCont,
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
          const SizedBox(height: 40),
          BottomText(
            text: "Already have an account?",
            text2: " Log in",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
