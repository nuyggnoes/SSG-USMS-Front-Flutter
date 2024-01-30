import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // 비디오 URL을 전달하여 VideoPlayerController를 초기화합니다.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://usms-media.serveftp.com/video/hls/replay/0e798b6c-2b80-47d6-beae-95435399fb7d/0e798b6c-2b80-47d6-beae-95435399fb7d-1706599796.m3u8'),
      formatHint: VideoFormat.other,
    )..initialize().then((_) {
        // 비디오가 초기화되면 setState를 호출하여 UI를 갱신합니다.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
