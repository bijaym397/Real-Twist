import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/main.dart';
import 'package:real_twist/modals/user_modal.dart';
import 'package:real_twist/spinwheelscreen.dart';
import 'package:real_twist/utils/Back_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'game2.dart';
import 'menu.dart';
import 'notification.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserApiResponse? userDetails = UserApiResponse();
  String? token = "";

  @override
  void initState() {
    initSates();
    super.initState();
  }

  initSates() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString(AppStrings.spAuthToken);
    debugPrint("tokentoken ${token.toString()}");
    userDetails = await _show(token: token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade800,
          title: const Text("Real Twist"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationView()),
                );
              },
              child: Stack(
                children: [
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  )),
                  Positioned(
                      top: 5,
                      right: 7,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Text(
                            "21",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w800),
                          )))
                ],
              ),
            ),
          ],
          centerTitle: true,
        ),
        drawer: DrawerView(userDetails: userDetails, token: token.toString()),
        body: const HomeSideView(),
      ),
    );
  }

  Future<UserApiResponse?> _show({token}) async {
    try {
      debugPrint("tokendata ${token.toString()}");
      const apiUrl = "http://178.16.138.186:6000/api/user";
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': token.toString(),
        },
      );
      debugPrint("responseCode ${response.statusCode.toString()}");
      if (response.statusCode == 200) {
        customLoader!.hide();
        var data = UserApiResponse.fromJson(json.decode(response.body));
        debugPrint("responserese ${data.data!.name.toString()}");
        return data;
      } else {
        customLoader!.hide();
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      customLoader!.hide();
      debugPrint("error ${e.toString()}");
      return null;
    }
  }
}

class HomeSideView extends StatelessWidget {
  const HomeSideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Banner
          CarouselSlider(
            items: [
              const BannerImg(imgUrl: "assets/b2.png"),
              BannerImg(
                imgUrl: "assets/b1.png",
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SpinWheel(),
                  ),
                ),
              ),
              BannerImg(
                imgUrl: "assets/b3.jpeg",
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const NumberSpinner(),
                  ),
                ),
              ),
            ],
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayInterval: Duration(seconds: 10),
              viewportFraction: 1,
            ),
          ),
          const SizedBox(height: 24),

          /// Total coin Showing
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Coin",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                SizedBox(height: 8),
                Text(
                  "1,00,00,000",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// Total Investment
          const CommonCard(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Investment",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "11075.9692",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// Spin game
          GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const SpinWheel(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                // color: Colors.pink.shade500,
                gradient: LinearGradient(
                    colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
                image: DecorationImage(
                    image: const AssetImage("assets/spin_bg.jpeg"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(.3), BlendMode.dstATop)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Play And Win",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Play Daily and Earn Rewards",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset("assets/spin2.png", height: 100)),
                  const SizedBox(height: 16),
                  const Text(
                    "Spin Wheel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          /// Total Income
          const CommonCard(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Income",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "158.8",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// Casino
          GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const NumberSpinner(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink.shade900, Colors.black]),
                image: DecorationImage(
                    image: const AssetImage("assets/casino.jpeg"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(.2), BlendMode.dstATop)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "CASINO",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "WELCOME BONUS",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    "UP TO \$300",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 45,
                    width: 155,
                    child: CommonCard(
                      onTap: () {},
                      child: const Center(
                        child: Text(
                          "Play Now",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          /// Refer A Friend
          GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const NumberSpinner(),
              ),
            ),
            child: Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
                image: DecorationImage(
                  image: const AssetImage("assets/rafer.png"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 48)
        ],
      ),
    );
  }
}

class CommonCard extends StatelessWidget {
  const CommonCard({Key? key, this.padding, this.child, this.onTap})
      : super(key: key);
  final EdgeInsets? padding;
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}

class BannerImg extends StatelessWidget {
  const BannerImg({Key? key, this.imgUrl, this.onTap}) : super(key: key);
  final String? imgUrl;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(imgUrl ?? "assets/user.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "More Game",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
