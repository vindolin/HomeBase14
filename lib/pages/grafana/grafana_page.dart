import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/models/network_addresses.dart';

class GrafanaPage extends ConsumerStatefulWidget {
  const GrafanaPage({super.key});

  @override
  ConsumerState<GrafanaPage> createState() => _GrafanaPageState();
}

class _GrafanaPageState extends ConsumerState<GrafanaPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    final networkAddresses = ref.watch(networkAddressesProvider);

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
      ..loadRequest(Uri.parse(networkAddresses['grafana']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grafana 📊')),
      body: WebViewWidget(controller: controller),
    );
  }
}
