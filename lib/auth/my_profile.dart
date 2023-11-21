import 'package:flutter/material.dart';

final String name = "Bijay";
final String img = "assets/user.png";

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String name = "Bijay";
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("My Profile"),
      ),
      body: Column(
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
          const Text(
            "Bijay Mandal",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
    );
  }
}
