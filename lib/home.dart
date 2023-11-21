import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/spinwheelscreen.dart';
import 'package:real_twist/utils/Back_handler.dart';
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
        drawer: const DrawerView(),
        body: const HomeSideView(),
      ),
    );
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              // color: Colors.pink.shade500,
              gradient: LinearGradient(
                  colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
              // image: DecorationImage(
              //     image: const AssetImage("assets/banner.jpeg"),
              //     fit: BoxFit.fill,
              //     colorFilter: ColorFilter.mode(
              //         Colors.black.withOpacity(.2), BlendMode.dstATop)),
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
              child:  Column(
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
