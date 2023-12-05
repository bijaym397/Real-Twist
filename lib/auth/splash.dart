import 'package:flutter/material.dart';
import 'package:real_twist/admin/dashboard.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    initStates();
  }

  initStates() async {
    var authToken = await getToken();
    var userType = await getUser();
    Future.delayed(const Duration(seconds: 3), () {
      if (authToken?.isNotEmpty == true) {
        /// TODO Add version code api
        showTextFieldPopup(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => userType == Api.adminType
        //           ? const DashboardView()
        //           : HomeView()),
        // );
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      }
    });
  }

  Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString(AppStrings.spAuthToken);
    return token;
  }

  Future<String?> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user = sharedPreferences.getString(AppStrings.spUserType);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          TweenAnimationBuilder(
            builder: (BuildContext context, double? value, Widget? child) {
              return Transform.scale(scale: value, child: child);
            },
            tween: Tween(begin: .2, end: 2.0),
            duration: const Duration(seconds: 2),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("assets/spin2.png", height: 70)),
                const SizedBox(height: 6),
                Text(
                  "On",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.pink.shade600,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  "Real Twist",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            "Version 1.0.0",
            style: TextStyle(fontSize: 16, color: Colors.white38),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36)
        ],
      ),
    );
  }

  Future<void> showTextFieldPopup(BuildContext context) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 270,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("assets/spin2.png", height: 65)),
                const Spacer(),
                const Text(
                  "Exciting changes are on the way.",
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Thanks for your patience, we'll be back shortly.",
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: CommonCard(
                    onTap: () async {
                      SharedPreferences preference = await SharedPreferences.getInstance();
                      preference.setString(AppStrings.spAuthToken, "");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
