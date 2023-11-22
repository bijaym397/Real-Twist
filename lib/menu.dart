import 'package:flutter/material.dart';
import 'package:real_twist/auth/my_profile.dart';
import 'package:real_twist/change_password.dart';
import 'package:real_twist/constants/strings.dart';
import 'package:real_twist/modals/user_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'auth/login.dart';

class DrawerView extends StatelessWidget {
  final UserApiResponse? userDetails;
  final String? token;
  const DrawerView({Key? key, required this.userDetails, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Colors.transparent), //BoxDecoration
            child: Container(
              // padding: EdgeInsets.only(left: 90),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                    colors: [Colors.pink.shade900, Colors.pinkAccent.shade100]),
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                accountName: Text(
                  // "na",
                  userDetails!.data?.name.toString() ??
                  "N/A",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail:
                // Text(""),
                Text(userDetails!.data?.phoneNumber.toString() ?? "N/A",),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    (() {
                      final firstName = userDetails!.data?.name.toString();
                      if ((firstName?.isNotEmpty == true)) {
                        return (firstName![0].toUpperCase());
                      } else {
                        return "NA";
                      }
                    })(),
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ),
            ), //UserAccountDrawerHeader
          ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MyProfile(userDetails : userDetails),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Deposit'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Withdrawal '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Change Password'),
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(token: token.toString())));
            },
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_outlined),
            title: const Text('My Invest'),
            onTap: () {
              // Navigator.pop(context);
              _showTextFieldPopup(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.incomplete_circle),
            title: const Text('Total Income'),
            onTap: () {
              // Navigator.pop(context);
              _showTextFieldPopup(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text("Refer Friends & Earn"),
            onTap: () {
              // Navigator.pop(context);
              _showTextFieldPopup(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              // Navigator.pop(context);
              _showTextFieldPopup(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _showTextFieldPopup(BuildContext context) async {
  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Real Twist',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22),
              ),
              const Text("Are you sure you want to Logout your account!", textAlign: TextAlign.center,style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 18),),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonCard(
                        onTap: () async {
                          SharedPreferences preference = await SharedPreferences.getInstance();
                          preference.setString(AppStrings.spAuthToken, "");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Logout',
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
      );
    },
  );
}
