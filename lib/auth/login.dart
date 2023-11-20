// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:real_twist/otp_verification_screen.dart'; // Import the OTP verification screen
// import 'package:http/http.dart' as http;
//
// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);
//
//   @override
//   State<LoginView> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<LoginView> {
//   final TextEditingController phoneNumberController = TextEditingController();
//   final String countryCode = '+91'; // Static country code
//
//   Future<void> _hitLoginApi() async {
//     // final apiUrl = '{{host}}login';
//     // final response = await http.post(
//     //   Uri.parse(apiUrl),
//     //   headers: {'Content-Type': 'application/json'},
//     //   body: jsonEncode({
//     //     'phoneNumber': '$countryCode${phoneNumberController.text}',
//     //     'countryCode': countryCode,
//     //   }),
//     // );
//     //
//     // if (response.statusCode == 200) {
//       // API call successful
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("OTP sent to your phone."),
//         ),
//       );
//
//       // Navigate to OTP verification screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OtpVerificationScreen(
//             phoneNumber: '$countryCode${phoneNumberController.text}',
//           ),
//         ),
//       );
//     // } else {
//     //   // API call failed
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(
//     //       content: const Text("Failed to send OTP. Please try again."),
//     //     ),
//     //   );
//     //}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             const SizedBox(height: 120),
//             const Center(
//                 child: Text(
//               "Welcome to",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
//             )),
//             const SizedBox(height: 8),
//             const Center(
//                 child: Text(
//               "Real Twist",
//               style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
//             )),
//             const SizedBox(height: 60),
//             TextFormField(
//               controller: phoneNumberController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.phone),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter Your Phone Number',
//                 labelText: "Enter Your Phone Number",
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             SizedBox(
//               height: 45,
//               child: ElevatedButton(
//                 child: const Text("Login", style: TextStyle(fontSize: 18)),
//                 onPressed: _hitLoginApi, // Call the API function on button press
//               ),
//             ),
//             const SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }

///

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/home.dart';
import 'package:real_twist/main.dart';
import 'package:real_twist/modals/login_data_modal.dart';
import 'package:real_twist/auth/signUp.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_verification_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Form(
          key: loginFormKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 100),
              const Center(
                  child: Text(
                "Welcome to",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              )),
              const SizedBox(height: 8),
              const Center(
                  child: Text(
                "Real Twist",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
              )),
              const SizedBox(height: 68),
              TextFormField(
                focusNode: phoneNode,
                controller: phoneController,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "*Required";
                  if (value.length < 10) {
                    return "Length should be 10";
                  }
                  // if (!value.isValidPhone()) return "Invalid Phone Number";
                  // return null;
                },
                // validator: FromValidator.phoneValidator,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                focusNode: passwordNode,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "*Required";
                  if (value.length < 8) {
                    return "Password must contain at least 8 characters.";
                  }
                  // if (!value.isValidPassword()){
                  // return "Password must contain at least 8 characters.";
                  // }
                  return null;
                },
                // validator: FromValidator.passwordValidator,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(),
                    hintText: 'Enter You Password',
                    labelText: "Enter You Password"),
              ),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      _showTextFieldPopup(context);
                    },
                    child: const Text(
                      "Forgot Password",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  )),
              const SizedBox(height: 32),
              SizedBox(
                height: 45,
                child: CommonCard(
                  onTap: () {
                    if (loginFormKey.currentState!.validate()) {
                      _hitLoginApi(
                        phone: phoneController.text.trim(),
                        countryCode: "91",
                        password: passwordController.text.trim(),
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupView()),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You don't have a account, ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink.shade400),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.pinkAccent.shade100),
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

  Future<void> _hitLoginApi(
      {String? countryCode, String? phone, String? password}) async {
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
            builder: (context) => const HomeView(),
          ),
        ).then((value) => {
              sharedPreferences.setString(
                  AppStrings.spUserId, loginData.data!.userId.toString()),
        sharedPreferences.setString(
              AppStrings.spAuthToken, loginData.data!.userId.toString()),
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OtpVerificationScreen(
        //       phoneNumber: '$countryCode${phone.toString()}',
        //     ),
        //   ),
        // ).then((value) {
        //   sharedPreferences.setString(
        //       AppStrings.spUserId, loginData.data!.userId.toString());
        //   sharedPreferences.setString(
        //       AppStrings.spAuthToken, loginData.data!.userId.toString());
        // });
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

Future<void> _showTextFieldPopup(BuildContext context) async {
  TextEditingController _textFieldController = TextEditingController();
  FocusNode forgotFocusNode = FocusNode();

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Forgot Password'),
              TextFormField(
                controller: _textFieldController,
                focusNode: forgotFocusNode,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(),
                    hintText: '+91 xxxx nnnnnn',
                    labelText: "Enter You Number"),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonCard(
                        onTap: () => Navigator.pop(context),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonCard(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtpVerificationScreen(
                                phoneNumber: '9088099176',
                              ),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
