import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:real_twist/otp_verification_screen.dart'; // Import the OTP verification screen
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController phoneNumberController = TextEditingController();
  final String countryCode = '+91'; // Static country code

  Future<void> _hitLoginApi() async {
    // final apiUrl = '{{host}}login';
    // final response = await http.post(
    //   Uri.parse(apiUrl),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'phoneNumber': '$countryCode${phoneNumberController.text}',
    //     'countryCode': countryCode,
    //   }),
    // );
    //
    // if (response.statusCode == 200) {
      // API call successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("OTP sent to your phone."),
        ),
      );

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            phoneNumber: '$countryCode${phoneNumberController.text}',
          ),
        ),
      );
    // } else {
    //   // API call failed
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text("Failed to send OTP. Please try again."),
    //     ),
    //   );
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 120),
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
            const SizedBox(height: 60),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                border: OutlineInputBorder(),
                hintText: 'Enter Your Phone Number',
                labelText: "Enter Your Phone Number",
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 45,
              child: ElevatedButton(
                child: const Text("Login", style: TextStyle(fontSize: 18)),
                onPressed: _hitLoginApi, // Call the API function on button press
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:real_twist/home.dart';
// import 'package:real_twist/signUp.dart';
//
// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);
//
//   @override
//   State<LoginView> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<LoginView> {
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
//             const SizedBox(height: 26),
//             TextFormField(
//               decoration: const InputDecoration(
//                   prefixIcon: Icon(Icons.phone),
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter Your Phone Number',
//                   labelText: "Enter Your Phone Number"),
//             ),
//             const SizedBox(height: 24),
//        /*     TextFormField(
//               decoration: const InputDecoration(
//                   contentPadding:
//                   EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   prefixIcon: Icon(Icons.key),
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter You Password',
//                   labelText: "Enter You Password"),
//             ),
//             const SizedBox(height: 12),*/
//            /* const Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "Forgot Password",
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//                 )),*/
//             const SizedBox(height: 24),
//             SizedBox(
//               height: 45,
//               child: ElevatedButton(
//                 child: const Text("Login", style: TextStyle(fontSize: 18),),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const HomeView()),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 60),
//        /*     GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignupView()),
//                 );
//               },
//               child: RichText(
//                 textAlign: TextAlign.center,
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "You don't have a account, ",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white),
//                     ),
//                     TextSpan(
//                       text: "Sign Up",
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),*/
//           ],
//         ),
//       ),
//     );
//   }
// }
