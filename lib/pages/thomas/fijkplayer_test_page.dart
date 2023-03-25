// import 'package:flutter/material.dart';
// import 'package:fijkplayer/fijkplayer.dart';

// class VideoScreen extends StatefulWidget {
//   final String url;

//   const VideoScreen({super.key, required this.url});

//   @override
//   VideoScreenState createState() => VideoScreenState();
// }

// class VideoScreenState extends State<VideoScreen> {
//   final FijkPlayer player = FijkPlayer();

//   VideoScreenState();

//   @override
//   void initState() {
//     super.initState();
//     player.setDataSource(widget.url, autoPlay: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Fijkplayer Example")),
//         body: Container(
//           alignment: Alignment.center,
//           child: FijkView(
//             player: player,
//           ),
//         ));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     player.release();
//   }
// }
