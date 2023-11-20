import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/home.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> _hitVerifyOtpApi() async {
    final apiUrl = '{{host}}verifyOtp';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': '654ca1fe7470d369ff94735c',
        'phoneNumber': widget.phoneNumber,
        'verificationCode': int.tryParse(otpController.text) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      // API call successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("OTP verification successful."),
        ),
      );

      // Navigate to the home screen (replace with the actual home screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
      // } else {
      //   // API call failed
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: const Text("OTP verification failed. Please try again."),
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Text(
                'Enter the OTP sent to ${widget.phoneNumber}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(),
                  hintText: 'Enter OTP',
                  labelText: 'Enter OTP',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Verify OTP", style: TextStyle(fontSize: 18)),
                  onPressed: _hitVerifyOtpApi,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
