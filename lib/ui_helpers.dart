import 'dart:ui';

import 'package:flutter/material.dart';

/// Shows a modal dialog with a blurred background.
modalDialog(context, child, {BoxConstraints? constraints}) {
  showDialog(
    context: context,
    builder: (_) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: ConstrainedBox(
            constraints: constraints ?? const BoxConstraints(maxHeight: double.infinity),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}
