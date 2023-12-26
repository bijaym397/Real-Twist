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
        if (DateTime.now().difference(_lastExitTime) > Duration(seconds: 2)) {
          //showing message to user
          final snack =  SnackBar(
            content:  Text("Press the back button again to exist the app"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return Future.value(false); // disable back press
        } else {
          return Future.value(true); //  exit the app
        }
      },
      child: child,
    );

  }
}

/*
import 'dart:async';

import 'package:flutter/material.dart';

class BackHandler extends StatelessWidget {
  const BackHandler({Key? key, this.onTap, required this.child})
      : super(key: key);

  final Future<bool> Function()? onTap;
  final Widget child;
  bool tapped = false;
  bool condition = true;
  int waitForSecondBackPress = 2;

  @override
  Widget build(BuildContext context) {

    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: onTap ?? () async {
        if (condition) {
          if (tapped) {
            return true;
          } else {
            tapped = true;
            Timer(
              Duration(
                seconds: waitForSecondBackPress,
              ),
              resetBackTimeout,
            );

            if (widget.onFirstBackPress != null) {
              widget.onFirstBackPress!(context);
            } else {
              final snack =  SnackBar(
                content:  Text("Press the back button again to exist the app"),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            }

            return false;
          }
        } else {
          if (onConditionFail != null) {
            onConditionFail!();
          }
          return false;
        }
      },
      child: child,
    );

  }

  void resetBackTimeout(){
    tapped = false;
  }

}*/
