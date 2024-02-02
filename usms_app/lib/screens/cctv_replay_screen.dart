import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/services/cctv_service.dart';
import 'package:video_player/video_player.dart';

class CCTVReplay extends StatefulWidget {
  const CCTVReplay({
    super.key,
    required this.cctv,
    required this.userId,
    required this.storeId,
  });
  final CCTV cctv;
  final int userId;
  final int storeId;

  @override
  State<CCTVReplay> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CCTVReplay> {
  static late Future<List<dynamic>> cctvReplayUrlList;
  DateTime selectedDate = DateTime.now();
  // static List<VideoPlayerController> videoList = [];
  static late List<ChewieController?> chewieControllers;
  static late List<VideoPlayerController?> videoControllers;
  static List<dynamic> testList = [];

  // final List<Item> data = generateItems(24);
  late List<Item> data;

  @override
  initState() {
    chewieControllers = [];
    videoControllers = [];
    selectedDate = DateTime.now();
    _fetchReplays();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('==============didChangeDenpendecies==================');
    // data = generateItems(testList.length);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('dispose()');
    for (var i = 0; i < videoControllers.length; i++) {
      print('dispose for()');
      if (videoControllers[i] != null) {
        videoControllers[i]!.dispose();
      }
      if (chewieControllers[i] != null) {
        chewieControllers[i]!.dispose();
      }
    }
    super.dispose();
  }

  getUrl(int index) async {
    await _fetchReplays();
    List<dynamic> urlList = await cctvReplayUrlList;
    return urlList[index];
  }

  Future<void> _fetchReplays() async {
    try {
      var returnValues = await CCTVService.getAllCCTVReplay(
        context: context,
        userId: widget.userId,
        storeId: widget.storeId,
        date: selectedDate,
        cctv: widget.cctv,
      );
      print('getAllCCTVReplay Return [$returnValues]');

      setState(() {
        cctvReplayUrlList = Future.value(returnValues);
      });
      testList = await cctvReplayUrlList;
      print(testList[0]);
      print(testList.length);
    } catch (e) {
      print('[ERR] $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Item> data = generateItems(24);
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         SpinKitWave(
    //           color: Colors.blueAccent,
    //           duration: Duration(milliseconds: 2000),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    data = generateItems(testList.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cctv.cctvName} CCTV 다시보기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now(),
            onDateChanged: (DateTime date) async {
              setState(() {
                for (var i = 0; i < videoControllers.length; i++) {
                  print('dispose for()');
                  if (videoControllers[i] != null) {
                    videoControllers[i]!.dispose();
                  }
                  if (chewieControllers[i] != null) {
                    chewieControllers[i]!.dispose();
                  }
                }
                chewieControllers = [];
                videoControllers = [];
                selectedDate = date;

                // 다시보기 api 요청
                // 각 패널에 영상 넣기
              });
              await _fetchReplays();

              // 다시보기 cctv 조회
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: const EdgeInsets.all(0),
                expansionCallback: (int index, bool isExpanded) {
                  print('$index번 패널의 상태 : $isExpanded');
                  setState(() {
                    // 현재 패널의 상태를 반전하여 열기/닫기 토글
                    data[index].isExpanded = !isExpanded;
                    print('$index번 패널의 상태 : $isExpanded');

                    // 다른 패널들은 닫기
                    for (int i = 0; i < data.length; i++) {
                      if (i != index) {
                        data[i].isExpanded = false;
                      }
                    }
                  });

                  // setState(() {
                  //   data[index].isExpanded = !isExpanded;
                  // });
                  // if (data.any((item) => item.isExpanded)) {
                  //   int openedPanelIndex =
                  //       data.indexWhere((item) => item.isExpanded);
                  //   print(openedPanelIndex);

                  //   setState(() {
                  //     for (var item in data) {
                  //       item.isExpanded = false;
                  //     }
                  //   });
                  //   print('$index번 패널의 상태 : $isExpanded');
                  // }
                },
                children: data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(item.headerValue),
                      );
                    },
                    body: Container(
                      height: 300,
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: Center(
                        child: _buildVideoPlayer(item.replayUrl),
                      ),
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  Item({
    this.replayUrl,
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = true,
  });
  String expandedValue;
  String headerValue;
  bool isExpanded;
  String? replayUrl;
}

List<Item> generateItems(int numberOfItems) {
  print('generate items');
  List<String?> replayUrl = [];

  replayUrl = List<String?>.filled(24, null);
  print('testList 길이 : ${_CalendarScreenState.testList.length}');
  for (int i = 0; i < _CalendarScreenState.testList.length; i++) {
    replayUrl[i] = _CalendarScreenState.testList[i];
    print('replayurl $i : ${replayUrl[i]}');
  }

  return List<Item>.generate(numberOfItems, (int index) {
    String replayTime = '';
    int replayTimestamp = 0;

    if (replayUrl[index] != null) {
      // 타임스탬프로 headerValue 만들기
      var tmp = replayUrl[index]!.split('-').last;
      print('tmp : $tmp');
      replayTimestamp = int.parse(tmp.split('.').first);
      print(replayTimestamp);
      replayTime = DateTime.fromMillisecondsSinceEpoch(replayTimestamp * 1000)
          .toString();
      print('변환한 날짜 : $replayTime');
    }

    return Item(
      /// 헤더와 본문에 들어갈 내용
      headerValue: replayTime,
      expandedValue: 'This is item number $index',
      replayUrl: replayUrl[index],
    );
  });
}

Widget _buildVideoPlayer(String? videoUrl) {
  if (videoUrl != null) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      // 다양한 설정들을 추가할 수 있습니다.
    );
    _CalendarScreenState.chewieControllers.add(chewieController);
    _CalendarScreenState.videoControllers.add(videoPlayerController);

    return Chewie(controller: chewieController);
  } else {
    return const Text('다시보기 파일이 존재하지 않습니다.');
  }
}
