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
import 'package:real_twist/modals/forgot_modal.dart';
import 'package:real_twist/modals/login_data_modal.dart';
import 'package:real_twist/auth/signUp.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/utils/Back_handler.dart';
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
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return BackHandler(
      child: Scaffold(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      labelText: "Enter Your Phone Number",
                      counterText: "",
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  focusNode: passwordNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      prefixIcon: const Icon(Icons.key),
                      border: const OutlineInputBorder(),
                      hintText: 'Enter You Password',
                      labelText: "Enter You Password",
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
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignupView()),(Route<dynamic> route) => false);
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
      ),
    );
  }

  Future<void> _hitLoginApi(
      {String? phone, String? password}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "http://178.16.138.186:6000/api/login";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phone.toString(),
          'countryCode': "+91",
          'password': password.toString(),
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
        sharedPreferences.setString(
            AppStrings.spUserId, loginData.data!.userId.toString());
        sharedPreferences.setString(
            AppStrings.spAuthToken, loginData.data!.authToken.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
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

  Future<void> _hitForgotApi({String? phone}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "http://178.16.138.186:6000/api/forgot-password";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phone.toString(),
          'countryCode': "91",
        }),
      );
      final forgotData = ForgotApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${forgotData.message}"),
        ));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OtpVerificationScreen(
        token: forgotData.data!.token.toString(),phoneNumber: phone.toString())));
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${forgotData.message}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint(e.toString());
    }
  }

  Future<void> _showTextFieldPopup(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();
    FocusNode forgotFocusNode = FocusNode();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) {
        final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Form(
              key: forgotFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Forgot Password',style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: textFieldController,
                    focusNode: forgotFocusNode,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "*Required";
                      if (value.length < 10) {
                        return "Length should be 10";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(),
                      hintText: 'xxxxx xxxxx',
                      labelText: "Enter You Number",
                      counterText: "",
                    ),
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
                              if(forgotFormKey.currentState!.validate()){
                                _hitForgotApi(phone: textFieldController.text.trim());
                              }
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
          ),
        );
      },
    );
  }

}
