import 'package:flutter/material.dart';
import 'shader_widget.dart';

const _errorImage = AspectRatio(
  aspectRatio: 16 / 9,
  child: ShaderWidget('tv_static.frag'),
);

// Image(
//   filterQuality: FilterQuality.medium,
//   image: AssetImage('assets/images/gif/searching_eye.gif'),
// );

/// Network image that fades from the last image to the new image.
/// Transition duration can be set with [transitionDurationMs], defaults to 1sec.
class ImageFadeRefresh extends StatefulWidget {
  final String url;
  final int transitionDurationMs;

  const ImageFadeRefresh(
    this.url, {
    super.key,
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
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: LinearProgressIndicator(
            color: Colors.pink,
            backgroundColor: Colors.pink.withValues(alpha: 20),
            minHeight: 2,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // this is a workaround for the dreaded "Connection closed before full header was received" error
        // seems to be a framework bug
        if (error.toString().contains('full header')) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(),
          );
        } else {
          return _errorImage;
        }
      },
    );
    previousImage = newImage;
    return newImage;
  }

  @override
  void initState() {
    previousImage = _errorImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.center, child: previousImage),
        Align(
          alignment: Alignment.center,
          child: fetchImage(),
        ),
      ],
    );
  }
}
