import 'package:flutter/material.dart';

class RefreshableImage extends StatefulWidget {
  final String imageUrl;
  const RefreshableImage(this.imageUrl, {super.key});

  @override
  State<RefreshableImage> createState() => _RefreshableImageState();
}

class _RefreshableImageState extends State<RefreshableImage> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {}),
      child: Image.network('${widget.imageUrl}&${DateTime.now().millisecondsSinceEpoch}',
          filterQuality: FilterQuality.medium),
    );
  }
}
