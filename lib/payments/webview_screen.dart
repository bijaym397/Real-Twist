import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final Function(String) onPageFinished;
  late WebViewController controller;

  WebViewScreen(this.url, {super.key, required this.onPageFinished}){
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            onPageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(url));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('Payment screen'),
      ),
      backgroundColor: Colors.white,
      body: WebViewWidget(
       controller: controller,
      ),
    );
  }
}