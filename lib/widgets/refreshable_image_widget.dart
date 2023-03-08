import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'image_fade_refresh.dart';

class RefreshableImage extends ConsumerStatefulWidget {
  // this needs to be a ConsumerStatefulWidget because it needs to rebuild when tapped
  final String imageUrl;
  final StreamProvider? streamProvider; // refreshes the image when the stream emits
  final VoidCallback? onTap;

  const RefreshableImage(
    this.imageUrl, {
    this.streamProvider,
    this.onTap,
    super.key,
  });

  @override
  ConsumerState<RefreshableImage> createState() => _RefreshableImageState();
}

class _RefreshableImageState extends ConsumerState<RefreshableImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.streamProvider != null) {
      ref.watch(widget.streamProvider!);
    }

    return InkWell(
      onTap: widget.onTap,
      onDoubleTap: () => setState(() {}), // just refresh image
      child: ImageFadeRefresh(
        '${widget.imageUrl}&${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }
}
