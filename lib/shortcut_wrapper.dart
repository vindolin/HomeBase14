import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/utils.dart';

Widget shortcutWrapper(BuildContext context, Widget widget) {
  // wraps the widget so the ESC key can be used to go to the previous page when running on desktop
  return platformIsDesktop
      ? CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.escape): () {
              Navigator.pop(context);
            },
          },
          child: Focus(
            autofocus: true,
            child: widget,
          ),
        )
      : widget;
}
