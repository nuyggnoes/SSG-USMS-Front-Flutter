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
  late VideoPlayerController _videoController;
  // late VideoPlayerController _controller;
  late ChewieController _chewieController;
  // late ChewieController _chewieController2;

  // 페이지 상태 변화 변수(cctv 존재유무)
  final bool isCCTVExist = false;

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
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/replay/test2/test2-1704442722.m3u8';
    // String urlString =
    // 'https://usms.serveftp.com/video/hls/live/test2/index.m3u8';
    Uri uri = Uri.parse(urlString);

    _videoController = VideoPlayerController.networkUrl(uri);

    if (!_videoController.value.isInitialized) {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        aspectRatio: 16 / 9,
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!_videoController.value.isInitialized) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // } else {}
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
                          route: MaterialPageRoute(
                            builder: (context) => const CCTVScreen(),
                          ),
                          parentContext: context,
                          // videoPlayerController: _videoController,
                          // chewieController: _chewieController,
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
                    )
                  // : SingleChildScrollView(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Image.asset(
                  //           'assets/cctv_img.png',
                  //           // width: double.infinity,
                  //           scale: 5,
                  //         ),
                  //         const Column(
                  //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               '현재 매장에 등록된 CCTV가 존재하지 않습니다.',
                  //               style: TextStyle(fontWeight: FontWeight.w800),
                  //               softWrap: true,
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Text(
                  //               'CCTV를 등록하여 서비스를 이용해보세요.',
                  //               style: TextStyle(
                  //                 fontSize: 15,
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 30,
                  //             ),
                  //           ],
                  //         ),
                  //         // ElevatedButton(
                  //         //   onPressed: () {
                  //         //     showDialog(
                  //         //       barrierDismissible: false,
                  //         //       context: context,
                  //         //       builder: (context) {
                  //         //         return AlertDialog(
                  //         //           title: const Text('CCTV 별칭 설정'),
                  //         //           content: TextFormField(
                  //         //             decoration: const InputDecoration(
                  //         //                 labelText: 'CCTV 별칭'),
                  //         //           ),
                  //         //           actions: [
                  //         //             TextButton(
                  //         //               onPressed: () {
                  //         //                 Navigator.of(context).pop();
                  //         //               },
                  //         //               child: const Text('확인'),
                  //         //             ),
                  //         //           ],
                  //         //         );
                  //         //       },
                  //         //     );
                  //         //   },
                  //         //   style: ElevatedButton.styleFrom(
                  //         //     backgroundColor: Colors.blueAccent,
                  //         //   ),
                  //         //   child: const Text(
                  //         //     'CCTV 추가하기',
                  //         //     style: TextStyle(
                  //         //       color: Colors.white,
                  //         //       fontWeight: FontWeight.w900,
                  //         //     ),
                  //         //   ),
                  //         // ),
                  //         ExpansionTile(
                  //           title: const Text('CCTV 추가하기'),
                  //           children: <Widget>[
                  //             SizedBox(
                  //               width: double.infinity,
                  //               height: 230,
                  //               child: AdSlider(),
                  //             ),
                  //             TextFormField(
                  //               decoration:
                  //                   const InputDecoration(labelText: 'CCTV 별칭'),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(
                  //           height: 200,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
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
  // final VideoPlayerController videoPlayerController;
  // final ChewieController chewieController;

  const CustomBoxButton({
    super.key,
    required this.buttonText,
    required this.route,
    required this.parentContext,
    // required this.videoPlayerController,
    // required this.chewieController,
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
