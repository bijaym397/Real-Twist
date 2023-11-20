import 'package:flutter/material.dart';
import 'package:real_twist/auth/signUp.dart';

import '../home.dart';

class BottomText extends StatelessWidget {
  const BottomText({Key? key, this.onTap, this.text, this.text2})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final String? text2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap ??
            () {
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
                text: text ?? "You don't have a account, ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.pink.shade400),
              ),
              TextSpan(
                text: text2 ?? "Sign Up",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                    // color: Colors.pinkAccent.shade100
                ),
              ),
            ],
          ),
        ));
  }
}

class ButtonCommon extends StatelessWidget {
  const ButtonCommon({Key? key, this.onTap, this.title}) : super(key: key);
  final Function()? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: CommonCard(
        onTap: onTap ?? () {},
        child: Center(
          child: Text(
            title ?? 'Login',
            style:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
