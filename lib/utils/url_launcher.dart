import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher({required String url, String? title}) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) {
    throw Exception('Could not launch $uri');
  }
}

Future<void> share({required String shareUrl}) async {
  Share.share(shareUrl);
}