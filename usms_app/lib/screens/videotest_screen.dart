// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class MyMobileScreen extends StatefulWidget {
//   const MyMobileScreen({super.key, required this.});
//   final url;
//   final title;
//   final bitrate;

//   @override
//   State<MyMobileScreen> createState() => _MyMobileScreenState();
// }

// class _MyMobileScreenState extends State<MyMobileScreen> {
//   late VideoPlayerController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         setState(() {
//           controller.play();
//         });
//       });
//     controller.setClosedCaptionFile(Future.microtask(() async {
//       // use flutter_hls_parser package to look into the widget.url m3u8 stream file to look for the .webvtt url (sight)
//       Uri? subtitle = 'https://usms';
//       String fileContents = '';
//       if (subtitle != null) {
//         final resp = await http.get(subtitle);
//         fileContents = utf8.decode(resp.bodyBytes);
//       }
//       ClosedCaptionFile closedCaptionFile = WebVTTCaptionFile(fileContents);
//       return closedCaptionFile;
//     }));
//     controller.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('Playing ${widget.url} at ${widget.bitrate} bps');

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: Card(
//               elevation: 8.0,
//               clipBehavior: Clip.antiAlias,
//               margin: const EdgeInsets.all(16.0),
//               child: AspectRatio(
//                   aspectRatio: controller.value.aspectRatio,
//                   child: controller.value.isInitialized
//                       ? Stack(children: [
//                           VideoPlayer(controller),
//                           ClosedCaption(text: controller.value.caption.text),
//                         ])
//                       : const SizedBox.expand()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
