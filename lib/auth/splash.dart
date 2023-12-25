import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:real_twist/admin/dashboard.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> _checkVersionApi() async {
    const apiUrl = Api.baseUrl + Api.checkAppVersion;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 200) {
        return data["data"]["setting"]["version"] == Api.appVersion;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  initStates() async {
    String? authToken = await getToken();
    var userType = await getUser();
    debugPrint("checktoken ${authToken.toString()}");
    if (await _checkVersionApi()) {
      Future.delayed(const Duration(seconds: 3), () async {
        if (authToken != "" && authToken != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => userType == Api.adminType
                    ? const DashboardView()
                    : HomeView()),
          );
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        }
      });
    } else {
      showTextFieldPopup(context);
    }
  }

  Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(AppStrings.spAuthToken);
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
      body: ScaffoldBGImg(
        child: Column(
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
              "Version ${Api.appVersion}",
              style: TextStyle(fontSize: 16, color: Colors.white38),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36)
          ],
        ),
      ),
    );
  }

  Future<void> showTextFieldPopup(BuildContext context) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("assets/spin2.png", height: 65)),
                const Text(
                  "Exciting changes are on the way.",
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const Text(
                  "Thanks for your patience, we'll be back shortly.",
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "Please delete the old application & Download the new application from the link.",
                  maxLines: 20,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 40,
                  child: CommonCard(
                    onTap: _launchUrl,
                    child: const Center(
                      child: Text(
                        'Download Now',
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(
        Uri.parse("https://web.realtwist.tech/download-apk.html"))) {
      throw Exception('Could not launch');
    }
  }
}
