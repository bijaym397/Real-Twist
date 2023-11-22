import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/change_password.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/home.dart';
import 'package:real_twist/main.dart';
import 'package:real_twist/modals/otp_verification_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? verificationCode;
  final String? userId;
  final String? token;

  const OtpVerificationScreen({Key? key, this.phoneNumber, this.verificationCode, this.userId, this.token})
      : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();

  Future<void> _hitVerifyOtpApi() async {
    try{
      customLoader!.show(context);
      const apiUrl = '${Api.baseUrl}${Api.verifyOtp}';
      const forgotApiUrl = '${Api.baseUrl}${Api.verifyPasswordOtp}';
      Map payload = widget.token?.isNotEmpty == true ? {
        'token' : widget.token,
        'verificationCode': int.tryParse(otpController.text) ?? 0,
      } :
      {
        'userId': widget.userId.toString() ?? '654ca1fe7470d369ff94735c',
        'phoneNumber': widget.phoneNumber.toString(),
        'verificationCode': int.tryParse(otpController.text) ?? 0,
      };
      final response = await http.post(
        Uri.parse(widget.token?.isNotEmpty == true ? forgotApiUrl : apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload)
      );
      final verificationData = OtpVerificationResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        // API call successful
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("OTP verification successful."),
          ),
        );
        sharedPreferences.setString(
            AppStrings.spAuthToken, verificationData.data!.authToken.toString());
        // Navigate to the home screen (replace with the actual home screen)
        widget.token?.isNotEmpty == true ?  Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePassword(token: verificationData.data!.token.toString()),
          ),
        ): Navigator.pushReplacement(
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
      else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("OTP verification failed. Please try again."),
          ),
        );
      }
    }
    catch(e){
      customLoader!.hide();
      return debugPrint("errrior $e.toString()");
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
          child: Form(
            key: otpFormKey,
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
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    } else if (value.length < 6) {
                      return "Minimum length is 6";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: 'Enter OTP',
                    labelText: 'Enter OTP',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 45,
                  child: CommonCard(
                    onTap: (){
                      if(otpFormKey.currentState!.validate()){
                        _hitVerifyOtpApi();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Verify OTP',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
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
}
