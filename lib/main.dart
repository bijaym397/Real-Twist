import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:real_twist/auth/splash.dart';
import 'package:real_twist/utils/custom_loader.dart';

CustomLoader? customLoader;

void main()async {
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
  "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlQlGi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";

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
      home: const SplashView(),
    );
  }
}
