import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_twist/modals/home_details_modal.dart';
import 'package:real_twist/modals/user_modal.dart';

import '../home.dart';



class MyProfile extends StatelessWidget {
  final UserApiResponse userDetails;
  final HomeDetailsResponse homeDetails;
  final String? img = "assets/user.png";
  const MyProfile({Key? key, required this.userDetails, required this.homeDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = userDetails.data?.name.toString() ?? "N/A";
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.pink.shade800,
        title: const Text("My Profile"),
      ),
      body: Container(
        decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("assets/profile_bg.jpg"),
             fit: BoxFit.cover
           )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 65),
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white70,
                ),
                child: Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(img)),
                      color: Colors.pink.shade600, shape: BoxShape.circle),
                  child: img== "" ? Center(
                      child: Text(
                    name[0].toUpperCase(),
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 52),
                  )): SizedBox(),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                name.isNotEmpty ? name.toString().toUpperCase() : "N/A",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                  userDetails.data?.phoneNumber.toString() ?? "9988X-XXXXX",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                userDetails.data?.email.toString() ?? "N/A",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const SizedBox(height: 10),
              userDetails.data?.userCode.toString().isNotEmpty == true?
              GestureDetector(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: userDetails.data?.userCode.toString() ?? "")).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Referral code copied"),
                      ),
                    );
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Referral Code : ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      userDetails.data?.userCode.toString() ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    const Icon((Icons.copy))
                  ],
                ),
              ):const SizedBox(),
          const SizedBox(height: 50),
              const Spacer(),
               Row(
                children: [
                  Expanded(
                    child: CommonCard(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "My Investment",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text( homeDetails.data?.totalInvestment?.toStringAsFixed(2) ?? "0.00",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: CommonCard(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total Income",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            homeDetails.data?.totalIncome?.toStringAsFixed(2) ?? "0.00",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
