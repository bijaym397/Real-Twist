import 'dart:math';

import 'package:flutter/material.dart';
import 'package:real_twist/auth/splash.dart';
import 'package:real_twist/utils/custom_loader.dart';

import 'admin/dashboard.dart';

CustomLoader? customLoader;

void main() async {
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  customLoader = CustomLoader();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Twist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const DashboardView(),
    );
  }
}
