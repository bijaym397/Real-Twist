import 'dart:convert';

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

   UserApiResponse? userDetails;

  @override
  void initState() {
    initSates();
    super.initState();
  }

  initSates() async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(AppStrings.spAuthToken);
    debugPrint("tokentoken ${token.toString()}");
    userDetails = await _show(token: token);
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
        ),
        drawer: DrawerView(userDetails: userDetails),
        body: const HomeSideView(),
      ),
    );
  }

  Future<UserApiResponse?> _show({token}) async {
    try{
      debugPrint("tokendata ${token.toString()}");
      const apiUrl = "http://178.16.138.186:6000/api/user";
      var response =
      await http.get(Uri.parse(apiUrl),
        headers: {
        'Content-Type': 'application/json',
          'token' : token.toString(),
      },);
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
    }
    catch(e){
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
          const CommonCard(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
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
          Row(
            children: [
              const Expanded(
                child: CommonCard(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Gyre",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "11235.57",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: CommonCard(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(colors: [
                              Colors.purple.shade900,
                              Colors.purple.shade300
                            ]),
                          ),
                          child: const Text(
                            "GYRE 0.805900",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(colors: [
                              Colors.purple.shade900,
                              Colors.purple.shade300
                            ]),
                          ),
                          child: const Text(
                            "USDT O",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(
                child: CommonCard(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Investment",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "11075.9692",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: CommonCard(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Income",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "158.8",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CommonCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    "Deposit/Withdrawal Gyre",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Settle your transactions quickly",
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 24),
                  const Icon(Icons.payments_outlined, size: 80),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 8,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(colors: [
                                Colors.purple.shade600,
                                Colors.purple.shade300
                              ]),
                            ),
                            child: const Text(
                              "Deposit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          elevation: 8,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(colors: [
                                Colors.purple.shade600,
                                Colors.purple.shade300,
                              ]),
                            ),
                            child: const Text(
                              "Withdraw",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
          GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const NumberSpinner(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                // color: Colors.pink.shade500,
                gradient: LinearGradient(
                    colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
                image: DecorationImage(
                    image: const AssetImage("assets/assets/spin.jpeg"),
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
          SizedBox(
            height: 48,
          )
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
