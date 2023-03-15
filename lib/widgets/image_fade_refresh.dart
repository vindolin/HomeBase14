import 'package:flutter/material.dart';

/// Network image that transions from the last image to the new image.
/// Transition duration can be set with [transitionDurationMs], defaults to 1sec.
class ImageFadeRefresh extends StatefulWidget {
  final String url;
  final double? widthFactor;
  final int transitionDurationMs;

  const ImageFadeRefresh(
    this.url, {
    super.key,
    this.widthFactor,
    this.transitionDurationMs = 1000,
  });

  @override
  ImageFadeRefreshState createState() => ImageFadeRefreshState();
}

class ImageFadeRefreshState extends State<ImageFadeRefresh> {
  Widget? previousImage;

  Widget fetchImage() {
    final newImage = Image.network(
      widget.url,
      filterQuality: FilterQuality.medium,
      frameBuilder: (context, child, frame, _) {
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: Duration(milliseconds: widget.transitionDurationMs),
          curve: Curves.linear,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) => const Image(
        filterQuality: FilterQuality.medium,
        image: AssetImage('assets/images/gif/searching_eye.gif'),
      ),
    );
    previousImage = newImage;
    return newImage;
  }

  @override
  void initState() {
    previousImage = Center(
      widthFactor: widget.widthFactor,
      child: const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 6,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        previousImage!,
        fetchImage(),
      ],
    );
  }
}
