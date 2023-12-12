import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_twist/admin/payment_history.dart';
import 'package:real_twist/common/my_network.dart';
import 'package:real_twist/constants/api.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/main.dart';
import 'package:real_twist/modals/home_details_modal.dart';
import 'package:real_twist/modals/referral_response_modal.dart';
import 'package:real_twist/modals/user_modal.dart';
import 'package:real_twist/payments/icome_view.dart';
import 'package:real_twist/payments/my_invest.dart';
import 'package:real_twist/payments/payment_history.dart';
import 'package:real_twist/spinwheelscreen.dart';
import 'package:real_twist/utils/Back_handler.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/utils/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';
import 'game2.dart';
import 'menu.dart';

class HomeView extends StatefulWidget {
  bool? referCode;

  HomeView({Key? key, this.referCode}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserApiResponse? userDetails = UserApiResponse();
  HomeDetailsResponse? homeDetails = HomeDetailsResponse();
  String? token = "";
  String? userId = "";

  @override
  void initState() {
    initSates();
    super.initState();
  }

  initSates() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString(AppStrings.spAuthToken);
    userId = sharedPreferences.getString(AppStrings.spId);
    debugPrint("userId ${userId.toString()}");
    debugPrint("token ${token.toString()}");
    debugPrint("referCode ${widget.referCode}");
    if (widget.referCode == true) {
      _showReferralPopup(context);
    }
    if (token != null) {
      userDetails = await _show(token: token);
      homeDetails = await _homeDetails(token: token);
    }
    if (userDetails != null) {
      userDetails = userDetails;
      homeDetails = homeDetails;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade800,
          centerTitle: true,
          title: const Text("Real Twist"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentHistoryPage(
                          appBarTitle: "Notifications")),
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
        drawer: DrawerView(
            userDetails: userDetails!,
            homeDetails: homeDetails!,
            token: token.toString()),
        body: ScaffoldBGImg(child: HomeSideView(homeDetails: homeDetails!)),
      ),
    );
  }

  Future<UserApiResponse?> _show({token}) async {
    try {
      const apiUrl = "${Api.baseUrl}${Api.user}";
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': token.toString(),
        },
      );
      if (response.statusCode == 200) {
        customLoader!.hide();
        var data = UserApiResponse.fromJson(json.decode(response.body));
        return data;
      } else {
        customLoader!.hide();
        return null;
      }
    } catch (e) {
      customLoader!.hide();
      debugPrint("error ${e.toString()}");
      return null;
    }
  }

  Future<HomeDetailsResponse?> _homeDetails({token}) async {
    try {
      const apiUrl = "${Api.baseUrl}${Api.homeDetails}";
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': token.toString(),
        },
      );
      if (response.statusCode == 200) {
        customLoader!.hide();
        var data = HomeDetailsResponse.fromJson(json.decode(response.body));
        return data;
      } else {
        customLoader!.hide();
        return null;
      }
    } catch (e) {
      customLoader!.hide();
      debugPrint("error ${e.toString()}");
      return null;
    }
  }

  Future<void> _showReferralPopup(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();
    FocusNode referralFocusNode = FocusNode();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) {
        final GlobalKey<FormState> referralFormKey = GlobalKey<FormState>();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: Container(
            height: 160,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Form(
              key: referralFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Having Referral Code?',
                      style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: textFieldController,
                    focusNode: referralFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "*Required";
                      /*if (value.length < 10) {
                        return "Length should be 10";
                      }*/
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      prefixIcon: Icon(Icons.redeem_sharp),
                      border: OutlineInputBorder(),
                      hintText: 'xxxxx xxxxx',
                      labelText: "Enter referral code",
                      counterText: "",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonCard(
                            onTap: () => Navigator.pop(context),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CommonCard(
                            onTap: () {
                              if (referralFormKey.currentState!.validate()) {
                                _hitReferralApi(
                                  code: textFieldController.text.trim(),
                                  userId: userId.toString(),
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _hitReferralApi({String? code, String? userId}) async {
    try {
      customLoader!.show(context);
      const apiUrl = "${Api.baseUrl}${Api.referralCode}";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'referralCode': code.toString(),
          'userId': userId,
        }),
      );
      final referralData =
          ReferralApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${referralData.message}"),
        ));
        Navigator.pop(context);
      } else {
        // API call failed
        customLoader!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${referralData.message}"),
          ),
        );
      }
    } catch (e) {
      customLoader!.hide();
      return debugPrint(e.toString());
    }
  }
}

class HomeSideView extends StatelessWidget {
  final HomeDetailsResponse homeDetails;

  const HomeSideView({Key? key, required this.homeDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          CoinDetails(
            totalCoin: formatPercentage(double.parse(
                homeDetails.data?.totalUserCoins.toString() ?? "0.00")),
            coinPrice: homeDetails.data?.cra?.toStringAsFixed(2) ?? "0",
          ),

          /// Total Coins Available
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CommonCard(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Coins Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatPercentage(double.parse(homeDetails
                            .data?.totalCoins.toString() ?? "0.00")),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

         /* /// My Network
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CommonCard(
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const MyNetworkView(),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Network",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white.withOpacity(.7)),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.double_arrow_rounded)
                ],
              ),
            ),
          ),*/

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                /// Banner
                CarouselSlider(
                  items: [
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
                          builder: (BuildContext context) =>
                              const NumberSpinner(),
                        ),
                      ),
                    ),
                    const BannerImg(
                      imgUrl: "assets/b111.jpeg",
                      ind: 1,
                    ),
                  ],
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayInterval: const Duration(seconds: 6),
                    viewportFraction: 1,
                  ),
                ),
                const SizedBox(height: 24),

                /// Total Investment
                CommonCard(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentHistoryPage(
                              appBarTitle: 'My Investment History'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Investment",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: Colors.white.withOpacity(.7)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        homeDetails.data?.totalInvestment.toStringAsFixed(2) ?? "0.00",
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22),
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
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      // color: Colors.pink.shade500,
                      gradient: LinearGradient(colors: [
                        Colors.pink.shade900,
                        Colors.pinkAccent.shade100
                      ]),
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
                            child:
                                Image.asset("assets/spin2.png", height: 100)),
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
                CommonCard(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentHistoryPage(
                              appBarTitle: 'My Income History'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Income",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: Colors.white.withOpacity(.7)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        homeDetails.data?.totalIncome?.toStringAsFixed(2) ??
                            "0.00",
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22),
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
                    width: MediaQuery.of(context).size.width,
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
                            onTap: () => Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const NumberSpinner(),
                              ),
                            ),
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
                  onTap: () {
                    share(shareUrl: homeDetails.data!.appLink.toString());
                  },
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink.shade900,
                          Colors.pinkAccent.shade100
                        ],
                      ),
                      image: const DecorationImage(
                        image: AssetImage("assets/rafer.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 48)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommonCard extends StatelessWidget {
  const CommonCard({
    Key? key,
    this.padding,
    this.child,
    this.width,
    this.onTap,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? child;
  final width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
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
  const BannerImg({Key? key, this.imgUrl, this.onTap, this.ind})
      : super(key: key);
  final String? imgUrl;
  final int? ind;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage(imgUrl ?? "assets/user.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ind == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "More Game",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange.shade600,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}

class CoinDetails extends StatelessWidget {
  const CoinDetails(
      {Key? key, required this.totalCoin, required this.coinPrice})
      : super(key: key);
  final String totalCoin;
  final String coinPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 70,
          width: 170,
          margin: const EdgeInsets.only(bottom: 26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Real Twist Coin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  "Price ${coinPrice.toString()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent.shade100, Colors.pink.shade900]),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*const Text(
                  "Real Twist",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),*/

                const Text(
                  "Total Coins",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    totalCoin.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String formatPercentage(double percentage) {
  String normalizedPercentage = percentage.toString();

  if (normalizedPercentage.contains('.')) {
    int indexOfDecimal = normalizedPercentage.indexOf('.');
    String decimalPart = normalizedPercentage.substring(indexOfDecimal + 1);

    if (decimalPart.length > 2) {
      normalizedPercentage =
          normalizedPercentage.substring(0, indexOfDecimal + 3);
    }
  }

  return normalizedPercentage;
}
