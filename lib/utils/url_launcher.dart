import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher({required String url, String? title}) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
    throw Exception('Could not launch $uri');
  }
}

Future<void> share({required BuildContext context,required String shareUrl, String? referralCode}) async {
  final dir = await getTemporaryDirectory();
  final byte = (await rootBundle.load("assets/referralCodeImage.jpg")).buffer.asUint8List();
  final file = File("${dir.path}/Image.jpg");
  await file.writeAsBytes(byte);
  try{
    await Share.shareXFiles([XFile(file.path)], text: "${"Real Twist"}\n${referralCode != "" ? "Referral Code : " : ""} ${referralCode ?? ""} "" ${shareUrl}");
    Clipboard.setData(ClipboardData(text: "${referralCode != "" ? "Referral Code : " : ""} ${referralCode ?? ""}\n${shareUrl}")).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 70,
           ),
          content: const Text("If Referral link not send, Please paste it manually."),
        ),
      );
  });
  }
  catch(e){
    debugPrint('error sharing: $e');
  }
}