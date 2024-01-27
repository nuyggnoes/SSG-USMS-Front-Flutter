import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/screens/no_cctv_screen.dart';

import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/store_notification_screen.dart';

import 'package:usms_app/services/cctv_service.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/url.dart';
import 'package:usms_app/utils/user_provider.dart';

import 'package:usms_app/widget/custom_info_button.dart';
import 'package:usms_app/widget/custom_textFormField.dart';
import 'package:video_player/video_player.dart';

class StoreDetail2 extends StatefulWidget {
  const StoreDetail2({
    super.key,
    required this.storeId,
    required this.uid,
    required this.storeInfo,
  });
  final uid;
  final storeId;
  final storeInfo;

  @override
  State<StoreDetail2> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail2> {
  final CCTVService cctvService = CCTVService();
  late List<CCTV> cctvList;

  final List<String> urlStringList = [
    'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
    'https://strange-streaming'
  ];
  final List<VideoPlayerController> videoList = [];
  final List<ChewieController> chewieList = [];

  final _formKey = GlobalKey<FormState>();
  final cctvNameController = TextEditingController();

  CCTV cctv = CCTV(cctvName: 'cctvName1', storeId: 1);

  @override
  void initState() {
    super.initState();
    // 특정 회원의 특정 매장의 CCTV 정보를 가져온 후
    // 특정 매장에 cctv 정보가 없으면 페이지 상태 변화

    // setVideoPlayer();
  }

  String testText = '';

  Future<void> setVideoPlayer() async {
    for (var i = 0; i < urlStringList.length; i++) {
      try {
        videoList.add(
          VideoPlayerController.networkUrl(Uri.parse(urlStringList[i])),
        );
      } catch (e) {
        print('URL에서 비디오 로드 중 오류 발생: $e');
        // 다음 URL로 계속 진행하거나 필요에 따라 다르게 처리할 수 있습니다.
      }
      // videoList.add(
      //   VideoPlayerController.networkUrl(Uri.parse(urlStringList[i])),
      // );
    }
    for (var i = 0; i < videoList.length; i++) {
      ChewieController chewieController;
      if (!videoList[i].value.isInitialized) {
        try {
          await videoList[i].initialize();
          // 이벤트 리스너 추가
          chewieController = ChewieController(
            videoPlayerController: videoList[i],
            autoPlay: false,
            aspectRatio: 16 / 9,
          );
          chewieList.add(chewieController);
        } catch (e) {
          print('URL에 대한 비디오 플레이어 초기화 중 오류 발생: ${urlStringList[i]}');
          var errorChewie =
              ChewieController(videoPlayerController: videoList[i]);
          chewieList.add(errorChewie);
          print('URL에 대한 비디오 플레이어 초기화 중 오류 발생: ${videoList[i]}');
        }
        // await videoList[i].initialize();
        // // add EventListener
        // var chewieController = ChewieController(
        //   videoPlayerController: videoList[i],
        //   autoPlay: false,
        //   aspectRatio: 16 / 9,
        // );
        // chewieList.add(
        //   // ChewieController(
        //   //   videoPlayerController: videoList[i],
        //   //   autoPlay: false,
        //   //   aspectRatio: 16 / 9,
        //   // ),
        //   chewieController,
        // );
      }
    }
    setState(() {});
  }

  ChewieController setController(String cctvStreamKey) {
    ChewieController chewieController;
    var videoUrl = '${UrlConfig.mediaUrl}/$cctvStreamKey/index.m3u8';
    var videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    // if (!videoController.value.isInitialized) {
    //   videoController.initialize();

    //   chewieController = ChewieController(
    //     videoPlayerController: videoController,
    //     autoPlay: false,
    //     aspectRatio: 16 / 9,
    //   );
    // }
    while (!videoController.value.isInitialized) {
      videoController.initialize();
    }
    chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      aspectRatio: 16 / 9,
    );

    return chewieController;
  }

  @override
  void dispose() {
    // _videoController.dispose();
    // _chewieController.dispose();
    // _controller.dispose();
    // _chewieController2.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('${widget.storeInfo.name}'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('CCTV 추가하기'),
                      content: Form(
                        key: _formKey,
                        child: CustomTextFormField(
                          labelText: 'CCTV명',
                          maxLength: 20,
                          counterText: '',
                          textController: cctvNameController,
                          textType: TextInputType.text,
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return 'CCTV명을 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () {
                            cctvNameController.text = '';
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('확인'),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              cctvService.registerCCTV(
                                context: context,
                                storeId: widget.storeId,
                                uid: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .id!,
                                name: cctvNameController.text,
                              );
                            }
                          },
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20,
            ),
            child: Column(
              children: [
                // chewieList.isEmpty
                //     ? const SizedBox(
                //         height: 620,
                //         child: Center(
                //           child: CircularProgressIndicator(),
                //         ),
                //       )
                //     : SizedBox(
                //         height: 620,
                //         child: ListView.builder(
                //           itemCount: chewieList.length,
                //           itemBuilder: (context, index) {
                //             print('chewieList 길이 : ${chewieList.length}');
                //             return ChewieListItem(
                //               chewieController: chewieList[index],
                //               index: index,
                //               routes: Routes.cctvReplay,
                //             );
                //           },
                //         ),
                //       ),

                FutureBuilder(
                  future: cctvService.getAllcctvList(
                    context: context,
                    storeId: widget.storeId,
                    uid: widget.uid,
                  ),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      List<CCTV> cctvList = snapshot.data!;

                      return SizedBox(
                        height: 620,
                        child: ListView.separated(
                          itemCount: cctvList.length,
                          itemBuilder: (context, index) {
                            CCTV cctv = cctvList[index];
                            if (cctv.isConnected) {
                              // 미디어 서버와 연결된 상태
                              var chewieController =
                                  setController(cctv.cctvStreamKey);
                              return ChewieListItem(
                                chewieController: chewieController,
                                index: index,
                                routes: Routes.cctvReplay,
                              );
                            }
                            return null;
                            // urlStringList.add(cctv.cctvStreamKey);
                            // videoController와 chewieController 등록.
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                        ),
                      );
                    } else {
                      return const NoCCTV();
                    }
                  }),
                ),
                Container(
                  height: 5,
                  width: 400,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // 버튼들
                CustomInfoButton(
                  buttonText: 'CCTV 설치 및 연결 방법',
                  parentContext: context,
                  route: Routes.cctvManual,
                  icon: Icons.collections_bookmark_rounded,
                ),
                // CustomInfoButton(
                //   buttonText: '매장별 알림 기록',
                //   parentContext: context,
                //   route: Routes.storeNotification,
                //   icon: Icons.notifications_active_rounded,
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoreNotification(
                                  storeId: widget.storeId,
                                )));
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text('매장별 알림 기록'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () async {
                      await StoreService.deleteStore(
                        context: context,
                        uid: widget.uid,
                        storeId: widget.storeId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      '매장 삭제',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
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
    bool isConnected = true;
    if (chewieController.videoPlayerController.value.errorDescription != null) {
      isConnected = false;
    }
    return Card(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isConnected
                ? SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Chewie(controller: chewieController),
                  )
                : const SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Center(
                      child: Text('동영상이 연결되어있지 않습니다.'),
                    ),
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const CCTVReplay()));
                          Navigator.pushNamed(
                            context,
                            Routes.cctvReplay,
                            arguments: 1,
                          );
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      IconButton(
                        onPressed: () {
                          print('key');
                        },
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

// class CustomBoxButton extends StatelessWidget {
//   final buttonText;
//   final MaterialPageRoute route;
//   final BuildContext parentContext;

//   const CustomBoxButton({
//     super.key,
//     required this.buttonText,
//     required this.route,
//     required this.parentContext,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(context, route);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           vertical: 10,
//           horizontal: 10,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey.shade400,
//               width: 2,
//             ),
//           ),
//         ),
//         height: 70,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('$buttonText'),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               color: Colors.grey.shade400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
