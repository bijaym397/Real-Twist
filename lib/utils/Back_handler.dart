import 'package:flutter/material.dart';

class BackHandler extends StatelessWidget {
  const BackHandler({Key? key, this.onTap, required this.child})
      : super(key: key);

  final Future<bool> Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: onTap ?? () async {
        if (DateTime.now().difference(_lastExitTime) >= Duration(seconds: 2)) {
          //showing message to user
          final snack =  SnackBar(
            content:  Text("Press the back button again to exist the app"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false; // disable back press
        } else {
          return true; //  exit the app
        }
      },
      child: child,
    );

  }
}