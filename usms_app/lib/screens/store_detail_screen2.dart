import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import 'package:provider/provider.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/screens/no_cctv_screen.dart';

import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/notification_list_screen.dart';
import 'package:usms_app/screens/store_notification_screen.dart';

import 'package:usms_app/services/cctv_service.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/cctv_provider.dart';
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
  List<CCTV> cctvList = [];

  final List<VideoPlayerController> videoList = [];
  final List<ChewieController?> chewieList = [];

  final _formKey = GlobalKey<FormState>();
  final cctvNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<ChewieController?> setController(CCTV cctv) async {
    if (cctv.isConnected) {
      print('isConnected true');
      var videoController = VideoPlayerController.networkUrl(
          Uri.parse(
              'https://usms-media.serveftp.com/video/hls/live/0e798b6c-2b80-47d6-beae-95435399fb7d/index.m3u8'),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      // 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8'));

      if (!videoController.value.isInitialized) {
        print('비디오 초기화 전');
        return await videoController.initialize().then((value) {
          videoList.add(videoController);
          print('videoList : $videoList');
          var chewieController = ChewieController(
            videoPlayerController: videoController,
            autoPlay: true,
            aspectRatio: 16 / 9,
          );
          print(chewieController);
          print('비디오 초기화 완료');
          return chewieController;
        });
      }
    } else {
      print('isConnected false');
      return null;
    }
    return null;
  }

  Future<List<ChewieController?>> setControllers(List<CCTV> cctvList) async {
    print('setControllers');
    print('cctvList : $cctvList');

    for (CCTV cctv in cctvList) {
      ChewieController? controller = await setController(cctv);
      print('${cctv.cctvName} controller : $controller');
      chewieList.add(controller);
    }
    return chewieList;
  }

  @override
  void dispose() {
    print('dispose()');
    for (var i = 0; i < videoList.length; i++) {
      print('dispose for()');
      videoList[i].dispose();
      if (chewieList[i] != null) {
        chewieList[i]!.dispose();
      }
    }
    super.dispose();
  }

  double listViewHeightCalculation(int storeListLength) {
    double cardHeight = 300.0;
    double totalHeight = cardHeight * storeListLength;
    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    var height = 300.0;
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
                    } else if (snapshot.hasError) {
                      print('에러 발생: ${snapshot.error}');
                      return Text('에러발생 : ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      print('snapshot.hasData');
                      cctvList = snapshot.data!;

                      // return SizedBox(
                      //   height: listViewHeightCalculation(cctvList.length),
                      //   child: ListView.separated(
                      //     itemCount: cctvList.length,
                      //     itemBuilder: (context, index) {
                      //       height = height * cctvList.length;
                      //       CCTV cctv = cctvList[index];
                      //       var chewieController = setController(cctv);
                      //       return ChewieListItem(
                      //         cctv: cctv,
                      //         chewieController: chewieController!,
                      //         index: index,
                      //         routes: Routes.cctvReplay,
                      //         uid: widget.uid,
                      //         storeId: widget.storeId,
                      //       );
                      //     },
                      //     separatorBuilder: (BuildContext context, int index) {
                      //       return const SizedBox(
                      //         height: 10,
                      //       );
                      //     },
                      //   ),
                      // );
                      return FutureBuilder<List<ChewieController?>>(
                        // future: Future.wait(
                        //   cctvList.map((cctv) => setController(cctv)),
                        // ),
                        future: setControllers(cctvList),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            print('컨트롤러 에러 발생: ${snapshot.error}');
                            return Text('컨트롤러 에러발생 : ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            print('snapshot : ${snapshot.data}');
                            List<ChewieController?> chewieControllers =
                                snapshot.data ?? [];
                            print('chewieControllerList : $chewieControllers');
                            return SizedBox(
                              height: 600,
                              // listViewHeightCalculation(cctvList.length),
                              child: ListView.separated(
                                itemCount: cctvList.length,
                                itemBuilder: (context, index) {
                                  height = 300.0;
                                  CCTV cctv = cctvList[index];
                                  ChewieController? chewieController =
                                      chewieControllers[index];
                                  print('========chwieListItem 직전=========');

                                  return ChewieListItem(
                                    cctv: cctv,
                                    chewieController: chewieController,
                                    index: index,
                                    routes: Routes.cctvReplay,
                                    uid: widget.uid,
                                    storeId: widget.storeId,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    } else {
                      return const NoCCTV();
                    }
                  }),
                ),
                // Stream Key Example
                // f6cddf98-777c-4bd5-9289-ce298bdd6140
                // 0e798b6c-2b80-47d6-beae-95435399fb7d

                //================================================================
                // Consumer<CCTVProvider>(
                //   builder: (context, cctvProvider, _) {
                //     List<CCTV> cctvList = cctvProvider.cctvList;
                //     return SizedBox(
                //       height: listViewHeightCalculation(cctvList.length),
                //       child: ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         padding: const EdgeInsets.symmetric(vertical: 30),
                //         itemCount: cctvList.length,
                //         itemBuilder: (context, index) {
                //           height = height * cctvList.length;
                //           CCTV cctv = cctvList[index];
                //           // setStoreProvider(store);
                //           //2. ListView를 생성할때 Store 각각을 StoreList.add() 를 통해 업데이트
                //           return Column(
                //             children: [
                //               cctv.isConnected
                //                   ? ChewieListItem(
                //                       chewieController: chewieController,
                //                       index: index,
                //                       routes: Routes.cctvReplay,
                //                     )
                //                   : const SizedBox(
                //                       height: 220,
                //                       width: double.infinity,
                //                       child: Center(
                //                         child: Text('동영상이 연결되어있지 않습니다.'),
                //                       ),
                //                     ),
                //               const SizedBox(
                //                 height: 20,
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(
                  height: 30,
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
                          builder: (context) => NotificationListScreen(
                                storeId: widget.storeId,
                                cctvList: cctvList,
                              )),
                    );
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
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('매장 삭제'),
                            content: const Text('정말 매장을 삭제하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('취소'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () async {
                                  await StoreService.deleteStore(
                                    context: context,
                                    uid: widget.uid,
                                    storeId: widget.storeId,
                                  );
                                },
                              )
                            ],
                          );
                        });
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
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text('매장 삭제'),
                          ],
                        ),
                      ],
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
  final ChewieController? chewieController;
  final int index;
  final String routes;
  final CCTV cctv;
  final int uid;
  final int storeId;

  const ChewieListItem({
    super.key,
    required this.chewieController,
    required this.index,
    required this.routes,
    required this.cctv,
    required this.uid,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    print('chewieListItem build');
    return Card(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            cctv.isConnected && chewieController != null
                ? SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Chewie(controller: chewieController!),
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
                  Text(
                    cctv.cctvName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          print('cctv 삭제');
                          CCTVService.deleteCCTV(
                              context: context,
                              uid: uid,
                              storeId: storeId,
                              cctvId: cctv.cctvId);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.cctvReplay,
                            arguments: cctv,
                          );
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      IconButton(
                        onPressed: () {
                          Future.microtask(() {
                            customShowDialog(
                                context: context,
                                title: 'CCTV Stream Key값',
                                message: cctv.cctvStreamKey,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          });
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
