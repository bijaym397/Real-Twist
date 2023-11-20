import 'package:flutter/material.dart';
import 'package:real_twist/payment_view.dart';

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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    });
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
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}
