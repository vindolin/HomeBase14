import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/styles/text_styles.dart';
import '/pages/thomas/thomas_page.dart';
import '/pages/grafana/grafana_page.dart';
import '/pages/thomas/dropdown_select_widget.dart';

/// Stuff only relevant for Thomas (only visible if user is Thomas)
class ThomasGroups extends ConsumerWidget {
  const ThomasGroups({super.key});
  final visualDensity = const VisualDensity(horizontal: 0, vertical: -3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    TextStyle titleStyle = textStyleShadowOne.copyWith(
      shadows: [
        Shadow(
          blurRadius: 2.0,
          color: brightness == Brightness.dark ? Colors.black : Colors.black45,
          offset: const Offset(1.0, 1.0),
        ),
      ],
    );

    final inactiveColor = WebViewPlatform.instance != null
        ? brightness == Brightness.dark
            ? Colors.white
            : Colors.black
        : Colors.grey;

    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: Text(
            'Thomas',
            style: titleStyle,
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              DropdownSelect(
                options: {
                  'wakeup': '☕️',
                  'sleep': '😴',
                  'hibernate': '🐻',
                },
                statTopic: 'leech/sleep',
                setTopic: 'leech/sleep/set',
              ),
              SizedBox(width: 8),
              DropdownSelect(
                options: {
                  'tv': '📺',
                  'monitor': '💻',
                },
                statTopic: 'leech/screens',
                setTopic: 'leech/screens/set',
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          // tileColor: Colors.purple.shade800,
          title: Text(
            'Grafana ${WebViewPlatform.instance != null ? '' : '(WebView is not available on this platform)'}',
            style: titleStyle.copyWith(
              color: inactiveColor,
            ),
          ),
          leading: Icon(Icons.auto_graph,
              color: WebViewPlatform.instance != null ? Theme.of(context).listTileTheme.iconColor : Colors.grey),
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
