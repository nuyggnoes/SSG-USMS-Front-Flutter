import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  test() {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(
            'https://usms-media.serveftp.com/video/hls/live/0e798b6c-2b80-47d6-beae-95435399fb7d/index.m3u8'));
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
    );
    return Chewie(controller: chewieController);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 400,
        child: test(),
      ),
    );
  }
}
