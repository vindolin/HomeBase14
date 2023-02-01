import 'package:flutter/material.dart';

abstract class CurtainPainterBase extends CustomPainter {
  // all sizes are computed relativ to the icon size of 24x24
  final baseSize = 24.0;
}

class CurtainPainter extends CurtainPainterBase {
  final double position;

  CurtainPainter(this.position);

  @override
  bool shouldRepaint(CurtainPainter oldDelegate) => oldDelegate.position != position;

  void paintBlinds(double topBarHeight, double blindsClosedHeight, double blindsPadding, Canvas canvas, Size size,
      Paint blindsPaint) {
    for (var i = topBarHeight; i < topBarHeight + blindsClosedHeight; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            blindsPadding,
            i.toDouble(),
            size.width - blindsPadding,
            i.toDouble() + 1,
          ),
          blindsPaint,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final blindsPadding = size.width / baseSize * 1.0;
    final topBarHeight = size.height / baseSize * 4.0;
    final bottomBarHeight = size.height / baseSize * 3.0;
    final blindsMaxHeight = size.height - (topBarHeight + bottomBarHeight);
    final blindsClosedHeight = blindsMaxHeight * (100 - position) / 100;

    final blindsPaint = Paint()..color = Colors.white;
    final stripDistance = size.width / baseSize * 3.0;
    final stripWidth = size.width / baseSize * 0.3;

    // left strip
    canvas.drawRect(
      Rect.fromLTRB(stripDistance, 0, stripDistance + stripWidth, size.height),
      blindsPaint,
    );
    // right strip
    canvas.drawRect(
      Rect.fromLTRB(size.width - stripDistance, 0, size.width - stripDistance - stripWidth, size.height),
      blindsPaint,
    );
    // top bar
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, topBarHeight),
      blindsPaint,
    );
    // bottom bar
    canvas.drawRect(
      Rect.fromLTRB(0, size.height - bottomBarHeight, size.width, size.height),
      blindsPaint,
    );

    paintBlinds(topBarHeight, blindsClosedHeight, blindsPadding, canvas, size, blindsPaint);
  }
}

class DualCurtainPainter extends CurtainPainterBase {
  // all sizes are computed relativ to the icon size of 24x24
  final baseSize = 24.0;
  final double leftPosition;
  final double rightPosition;

  DualCurtainPainter(this.leftPosition, this.rightPosition);

  @override
  bool shouldRepaint(DualCurtainPainter oldDelegate) => oldDelegate.leftPosition != leftPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final blindsPadding = size.width / baseSize * 1.0;
    final topBarHeight = size.height / baseSize * 4.0;
    final bottomBarHeight = size.height / baseSize * 3.0;
    final blindsMaxHeight = size.height - (topBarHeight + bottomBarHeight);
    final blindsClosedHeightLeft = blindsMaxHeight * (100 - leftPosition) / 100;
    final blindsClosedHeightRight = blindsMaxHeight * (100 - rightPosition) / 100;

    final blindsPaint = Paint()..color = Colors.white;
    final stripDistance = size.width / baseSize * 3.0;
    final stripWidth = size.width / baseSize * 0.3;

    // left strip
    canvas.drawRect(
      Rect.fromLTRB(stripDistance, 0, stripDistance + stripWidth, size.height),
      blindsPaint,
    );
    // right strip
    canvas.drawRect(
      Rect.fromLTRB(size.width - stripDistance, 0, size.width - stripDistance - stripWidth, size.height),
      blindsPaint,
    );
    // top bar
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, topBarHeight),
      blindsPaint,
    );
    // bottom bar
    canvas.drawRect(
      Rect.fromLTRB(0, size.height - bottomBarHeight, size.width, size.height),
      blindsPaint,
    );

    for (var i = topBarHeight; i < topBarHeight + blindsClosedHeightLeft; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            blindsPadding,
            i.toDouble(),
            size.width / 2,
            i.toDouble() + 1,
          ),
          blindsPaint,
        );
      }
    }
    for (var i = topBarHeight; i < topBarHeight + blindsClosedHeightRight; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            size.width - blindsPadding,
            i.toDouble(),
            size.width / 2,
            i.toDouble() + 1,
          ),
          blindsPaint,
        );
      }
    }

    final paint = Paint()..color = Colors.transparent;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
}
