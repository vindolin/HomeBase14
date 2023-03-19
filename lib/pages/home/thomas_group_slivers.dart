import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/styles/text_styles.dart';
import '/pages/thomas/thomas_page.dart';
import '/pages/grafana/grafana_page.dart';

/// Stuff only relevant for Thomas (only visible if user is Thomas)
class ThomasGroups extends ConsumerWidget {
  const ThomasGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: const Text(
            'Thomas',
            style: textStyleShadowOne,
          ),
          leading: const Icon(Icons.pest_control),
          visualDensity: visualDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThomasPage(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: Text(
            'Grafana ${WebViewPlatform.instance != null ? '' : '(WebView is not available on this platform)'}',
            style: textStyleShadowOne.copyWith(
              color: WebViewPlatform.instance != null ? Colors.white : Colors.grey,
            ),
          ),
          leading: Icon(Icons.auto_graph, color: WebViewPlatform.instance != null ? Colors.white : Colors.grey),
          visualDensity: visualDensity,
          onTap: () {
            WebViewPlatform.instance != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GrafanaPage(),
                    ),
                  )
                : null;
          },
        ),
        const Divider(),
      ]),
    );
  }
}
