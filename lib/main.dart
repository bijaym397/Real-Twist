import 'package:flutter/material.dart';
import 'package:real_twist/utils/custom_loader.dart';
import 'login.dart';

CustomLoader? customLoader;
void main() {
  customLoader = CustomLoader();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const LoginView(),
    );
  }
}
