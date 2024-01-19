import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/screen/cctv_detail_screen.dart';
import 'package:usms_app/screen/no_cctv_screen.dart';

import 'package:usms_app/screen/notification_list_screen.dart';
import 'package:usms_app/screen/statistic_screen.dart';

import 'package:usms_app/service/routes.dart';
import 'package:usms_app/widget/ad_slider.dart';
import 'package:video_player/video_player.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  final List<VideoPlayerController> videoList = [];
  final List<ChewieController> chewieList = [];
  late VideoPlayerController _videoController;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late ChewieController _chewieController2;

  // 페이지 상태 변화 변수(cctv 존재유무)
  final bool isCCTVExist = true;

  @override
  void initState() {
    super.initState();
    // 특정 회원의 특정 매장 정보를 가져온 후
    // 특정 매장에 cctv 정보가 없으면 페이지 상태 변화
    setVideoPlayer();
  }

  Future<void> setVideoPlayer() async {
    String urlString =
        'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';
    String urlString1 = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
    // String urlString =
    //     'https://usms.serveftp.com/video/hls/replay/test2/test2-1704442722.m3u8';
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/live/test2/index.m3u8';
    Uri uri = Uri.parse(urlString);
    Uri uri1 = Uri.parse(urlString1);

    _videoController = VideoPlayerController.networkUrl(uri);
    _controller = VideoPlayerController.networkUrl(uri1);

    if (!_videoController.value.isInitialized) {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        aspectRatio: 16 / 9,
      );
    }
    if (!_controller.value.isInitialized) {
      await _controller.initialize();
      _chewieController2 = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        aspectRatio: 16 / 9,
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    _controller.dispose();
    _chewieController2.dispose();
    super.dispose();
  }

  Widget buildVideoContainer() {
    return GestureDetector(
      onTap: () {
        print('video swap method');
        swapVideos();
      },
      child: Container(
        // height: 100,
        width: 270,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        // child: _videoController.value.isInitialized
        //     ? Chewie(controller: _chewieController)
        //     : const Center(
        //         child: CircularProgressIndicator(),
        //       ),
        child: _controller.value.isInitialized
            ? Chewie(controller: _chewieController2)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void swapVideos() {
    ChewieController tempController = _chewieController;
    _chewieController = _chewieController2;
    _chewieController2 = tempController;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Detail',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Text('특정 매장 이름'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              child: isCCTVExist
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          // width: 450,
                          height: 250,
                          // child: _videoController.value.isInitialized
                          //     ? AspectRatio(
                          //         aspectRatio: _videoController.value.aspectRatio,
                          //         child: VideoPlayer(_videoController),
                          //       )
                          //     : const Center(
                          //         child: CircularProgressIndicator(),
                          //       ),
                          child: _videoController.value.isInitialized
                              ? Chewie(controller: _chewieController)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 130,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              buildVideoContainer(),
                              const SizedBox(
                                width: 10,
                              ),
                              buildVideoContainer(),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            swapVideos();
                          },
                          child: const Text('test Button'),
                        ),
                        CustomBoxButton(
                          buttonText: 'CCTV 현황',
                          route: MaterialPageRoute(
                            builder: (context) => const CCTVScreen(),
                          ),
                          parentContext: context,
                        ),
                      ],
                    )
                  : const NoCCTV(),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBoxButton extends StatelessWidget {
  final buttonText;
  final MaterialPageRoute route;
  final BuildContext parentContext;

  const CustomBoxButton({
    super.key,
    required this.buttonText,
    required this.route,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('hi');

        Navigator.push(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$buttonText'),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
