import 'package:flutter/material.dart';
import 'package:real_twist/modals/user_modal.dart';

import '../home.dart';



class MyProfile extends StatelessWidget {
  final UserApiResponse? userDetails;
  final String? img = "assets/user.png";
  const MyProfile({Key? key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = userDetails!.data!.name.toString();
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("My Profile"),
      ),
      body: Padding(
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
              name.isNotEmpty ? name.toString() : "Bijay Mandal",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
                userDetails!.data!.phoneNumber.toString().isNotEmpty ? userDetails!.data!.phoneNumber.toString() : "9988X-XXXXX",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              // userDetails!.data!.email.toString().isNotEmpty ? userDetails!.data!.email.toString() : "N/A",
              "bijay@gmail.com",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
        const SizedBox(height: 50),
            const Spacer(),
            const Row(
              children: [
                Expanded(
                  child: CommonCard(
                    padding: EdgeInsets.symmetric(vertical: 4),
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
                    padding: EdgeInsets.symmetric(vertical: 4),
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
