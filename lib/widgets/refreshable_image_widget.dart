import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshableImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final StreamProvider? streamProvider;

  const RefreshableImage(this.imageUrl, {this.streamProvider, super.key});

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
      onTap: () => setState(() {}),
      child: Image.network('${widget.imageUrl}&${DateTime.now().millisecondsSinceEpoch}',
          filterQuality: FilterQuality.medium),
    );
  }
}
