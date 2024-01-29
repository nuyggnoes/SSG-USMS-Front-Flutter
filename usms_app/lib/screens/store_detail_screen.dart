import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/screens/cctv_detail_screen.dart';
import 'package:usms_app/screens/cctv_replay_screen.dart';
import 'package:usms_app/screens/hero_test_screen.dart';
import 'package:usms_app/screens/no_cctv_screen.dart';

import 'package:usms_app/screens/notification_list_screen.dart';
import 'package:usms_app/screens/statistic_screen.dart';

import 'package:usms_app/routes.dart';
import 'package:video_player/video_player.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  final List<String> urlStringList = [
    'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8',
    'https://usms.serveftp.com/video/hls/live/f6cddf98-777c-4bd5-9289-ce298bdd6140/index.m3u8',
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
  ];
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

  String testText = '';

  Future<void> setVideoPlayer() async {
    for (var i = 0; i < urlStringList.length; i++) {
      videoList.add(
        VideoPlayerController.networkUrl(Uri.parse(urlStringList[i])),
      );
    }
    // String urlString =
    // 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';
    String urlString =
        'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8';
    String urlString1 = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
    // String urlString =
    //     'https://usms.serveftp.com/video/hls/replay/test2/test2-1704442722.m3u8';
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/live/test2/index.m3u8';
    Uri uri = Uri.parse(urlString);
    Uri uri1 = Uri.parse(urlString1);

    _videoController = VideoPlayerController.networkUrl(uri);
    _controller = VideoPlayerController.networkUrl(uri1);
    for (var i = 0; i < videoList.length; i++) {
      if (!videoList[i].value.isInitialized) {
        await videoList[i].initialize();
        videoList[i].addListener(() {
          if (videoList[i].value.isPlaying) {
            print('비디오 플레이어 상태 확인 디버그 : ${videoList[i].value}');
            print(
                'hello I am CCTV $i video===============================================================');
            setState(() {
              testText = '별칭 : CCTV $i \nKey값 : 000607$i.';
            });
          }
        });
        var chewieController = ChewieController(
          videoPlayerController: videoList[i],
          autoPlay: false,
          aspectRatio: 16 / 9,
        );
        chewieList.add(
          // ChewieController(
          //   videoPlayerController: videoList[i],
          //   autoPlay: false,
          //   aspectRatio: 16 / 9,
          // ),
          chewieController,
        );
      }
    }
    if (!_videoController.value.isInitialized) {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
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
    for (var i = 0; i < chewieList.length; i++) {
      videoList[i].dispose();
      chewieList[i].dispose();
    }
    super.dispose();
  }

  Widget buildVideoContainer(
      {required ChewieController chewieController, required int idx}) {
    return Container(
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
      child: videoList[idx].value.isInitialized
          ? Chewie(controller: chewieController)
          : const Center(
              child: CircularProgressIndicator(),
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
                        SizedBox(
                          height: 250,
                          // child: ListView(
                          //   scrollDirection: Axis.horizontal,
                          //   children: [
                          //     buildVideoContainer(),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //     buildVideoContainer(),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //   ],
                          // ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chewieList.length,
                            itemBuilder: (context, index) {
                              return ChewieListItem(
                                chewieController: chewieList[index],
                                index: index,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 350,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 16 / 9, //item 의 가로 1, 세로 2 의 비율
                            ),
                            itemCount: chewieList.length +
                                (chewieList.length % 2 == 1 ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < chewieList.length) {
                                return ChewieListItem(
                                  chewieController: chewieList[index],
                                  index: index,
                                );
                              } else {
                                return Container(
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.videocam_off,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        // CustomBoxButton(
                        //   buttonText: 'CCTV 현황',
                        //   route: MaterialPageRoute(
                        //     builder: (context) => const CCTVScreen(),
                        //   ),
                        //   parentContext: context,
                        // ),
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

class ChewieListItem extends StatelessWidget {
  final ChewieController chewieController;
  final int index;

  const ChewieListItem({
    super.key,
    required this.chewieController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 330,
      child: Chewie(controller: chewieController),
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
