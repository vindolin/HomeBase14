import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/models/network_addresses.dart';

class DoorCamVideo extends StatefulWidget {
  const DoorCamVideo({super.key});

  @override
  State<DoorCamVideo> createState() => _DoorCamVideoState();
}

class _DoorCamVideoState extends State<DoorCamVideo> {
  late final WebViewController controller;

  @override
  void dispose() {
    controller.loadRequest(Uri.parse('about:blank')); // WebViewController.dispose() is not implemented :(
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(doorVideoWebsocketUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
