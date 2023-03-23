import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/models/secrets.dart' as secrets;

class GrafanaPage extends StatefulWidget {
  const GrafanaPage({super.key});

  @override
  State<GrafanaPage> createState() => _GrafanaPageState();
}

class _GrafanaPageState extends State<GrafanaPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(secrets.grafanaAdddress));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grafana 📊')),
      body: WebViewWidget(controller: controller),
    );
  }
}
