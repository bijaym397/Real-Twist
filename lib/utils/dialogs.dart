import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogHandler{
  /// Forgot Dialog
  void forgotDialog(BuildContext context, String message, String phone) {
    Alert(
      onWillPopActive: true,
      closeIcon: IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            // DialogHelper.closeDialog();
          },
          icon: Icon(Icons.close, color: Colors.grey)),
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
      ),
      context: context,
      /*image: Image.asset(
        "${AssetPath.logo}logo.png",
        fit: BoxFit.contain,
        width: 120,
        height: 50,
      ),*/
      title: "Forgot Password",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
                ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                phone == "" ? "" : "Phone: ",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              Text(
                "$phone",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),*/
          InkWell(
            onTap: () {
              // Navigator.of(context, rootNavigator: true).pop();
              closeDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xff0066b3),
              ),
              child : const Text(
                "Send",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    ).show();
  }

  static void closeDialog(context) {
      Navigator.pop(context);
  }

}