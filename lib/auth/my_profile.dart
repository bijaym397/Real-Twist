import 'package:flutter/material.dart';

final String name = "Bijay";

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.black,
        title: const Text("My Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 65),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.pink.shade600, shape: BoxShape.circle),
            child: Center(
                child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            )),
          ),
          const SizedBox(height: 32),
           const Text(
            "Bijay Mandal",
            textAlign: TextAlign.center,
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          // InputField(
          //   readOnly: !controller.isEdit.value,
          //   controller: controller.nameController,
          //   label: 'First Name',
          //   inputFormatters: <TextInputFormatter>[
          //     UpperCaseTextFormatter()
          //   ],
          //   validator: (value) {
          //     if (value == null || value.trim().isEmpty) {
          //       return "*Required";
          //     }
          //     return null;
          //   },
          // ),
          TextFormField(
            readOnly: true,
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
        ],
      ),
    );
  }
}
