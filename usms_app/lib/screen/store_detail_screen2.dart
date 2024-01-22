import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/screen/cctv_detail_screen.dart';
import 'package:usms_app/screen/cctv_replay_screen.dart';
import 'package:usms_app/screen/hero_test_screen.dart';
import 'package:usms_app/screen/no_cctv_screen.dart';

import 'package:usms_app/screen/notification_list_screen.dart';
import 'package:usms_app/screen/statistic_screen.dart';

import 'package:usms_app/service/routes.dart';
import 'package:usms_app/widget/ad_slider.dart';
import 'package:usms_app/widget/custom_textFormField.dart';
import 'package:video_player/video_player.dart';

class StoreDetail2 extends StatefulWidget {
  const StoreDetail2({super.key});

  @override
  State<StoreDetail2> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail2> {
  final List<String> urlStringList = [
    'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
  ];
  final List<VideoPlayerController> videoList = [];
  final List<ChewieController> chewieList = [];
  late VideoPlayerController _videoController;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late ChewieController _chewieController2;

  final _formKey = GlobalKey<FormState>();
  final cctvNameController = TextEditingController();

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
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: isCCTVExist
                    ? Column(
                        children: [
                          chewieList.isEmpty
                              ? const SizedBox(
                                  height: 620,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox(
                                  height: 620,
                                  child: ListView.builder(
                                    itemCount: chewieList.length,
                                    itemBuilder: (context, index) {
                                      return ChewieListItem(
                                        chewieController: chewieList[index],
                                        index: index,
                                        routes: Routes.cctvReplay,
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          ExpansionTile(
                            title: const Text('CCTV 추가하기'),
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: AdSlider(),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      textController: cctvNameController,
                                      textType: TextInputType.text,
                                      labelText: 'CCTV 별칭',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'CCTV 별칭을 입력해주세요.';
                                        }
                                        return null;
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          print('빈칸 없음');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                      child: const Text(
                                        'CCTV 추가하기',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                print('cctv 설치방법');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                'CCTV 설치 및 연결 방법',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const NoCCTV(),
              ),
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
  final String routes;

  const ChewieListItem({
    super.key,
    required this.chewieController,
    required this.index,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Chewie(controller: chewieController),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CCTV 1',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CCTVReplay()));
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.key),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
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
