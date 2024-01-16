import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/screen/cctv_detail_screen.dart';
import 'package:usms_app/screen/notification_list_screen.dart';
import 'package:usms_app/screen/statistic_screen.dart';
import 'package:video_player/video_player.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});
  static const route = 'store-detail';

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  late VideoPlayerController _videoController;
  // late VideoPlayerController _controller;
  late ChewieController _chewieController;
  // late ChewieController _chewieController2;

  @override
  void initState() {
    super.initState();
    setVideoPlayer();
  }

  Future<void> setVideoPlayer() async {
    String urlString =
        'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/replay/test2/test2-1704442722.m3u8';
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/live/test2/index.m3u8';
    Uri uri = Uri.parse(urlString);

    _videoController = VideoPlayerController.networkUrl(uri);

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      aspectRatio: 16 / 9,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {}
    return MaterialApp(
      title: 'Store Detail',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 10,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text('매장 현황'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              child: SizedBox(
                child: Column(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          width: 190,
                          height: 107,
                          // child: _videoController.value.isInitialized
                          //     ? Chewie(controller: _chewieController)
                          //     : const Center(
                          //         child: CircularProgressIndicator(),
                          //       ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          width: 190,
                          height: 107,
                          // child: _videoController.value.isInitialized
                          //     ? Chewie(controller: _chewieController)
                          //     : const Center(
                          //         child: CircularProgressIndicator(),
                          //       ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomBoxButton(
                      buttonText: 'CCTV 현황',
                      routeName: CCTVScreen.route,
                      parentContext: context,
                      videoPlayerController: _videoController,
                      chewieController: _chewieController,
                    ),
                    // CustomBoxButton(
                    //   buttonText: '지난 알림 목록',
                    //   routeName: NotificationListScreen.route,
                    //   parentContext: context,
                    // ),
                    // CustomBoxButton(
                    //   buttonText: '통계 지표',
                    //   routeName: StatisticScreen.route,
                    //   parentContext: context,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBoxButton extends StatelessWidget {
  final buttonText;
  final routeName;
  final BuildContext parentContext;
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;

  const CustomBoxButton({
    super.key,
    required this.buttonText,
    required this.routeName,
    required this.parentContext,
    required this.videoPlayerController,
    required this.chewieController,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('hi');
        Navigator.pushNamed(parentContext, routeName);
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
