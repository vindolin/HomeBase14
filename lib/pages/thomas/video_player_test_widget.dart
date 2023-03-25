// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import '/models/secrets.dart';

// class VideoPlayerTestWidget extends StatefulWidget {
//   const VideoPlayerTestWidget({super.key});

//   @override
//   State<VideoPlayerTestWidget> createState() => _VideoPlayerTestWidgetState();
// }

// class _VideoPlayerTestWidgetState extends State<VideoPlayerTestWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
//     _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _controller.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             )
//           : Container(),
//     );
//   }
// }
