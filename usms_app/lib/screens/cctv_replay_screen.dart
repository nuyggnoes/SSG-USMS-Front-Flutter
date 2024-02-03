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
  State<CCTVReplay> createState() => CCTVReplayState();
}

class CCTVReplayState extends State<CCTVReplay> {
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
    data = generateItems(testList.length);
    print('chewie 길이 : ${CCTVReplayState.chewieControllers.length}');
    print('video 길이 : ${CCTVReplayState.videoControllers.length}');

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
              });
              await _fetchReplays();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: data.isNotEmpty
                ? ExpansionPanelListExample(
                    // getAllreplay
                    datas: testList,
                  )
                // ? ExpansionPanelList(
                //     elevation: 1,
                //     expandedHeaderPadding: const EdgeInsets.all(0),
                //     expansionCallback: (int index, bool isExpanded) {
                //       setState(() {
                //         // 현재 패널의 상태를 반전하여 열기/닫기 토글
                //         // 다른 패널들은 닫기
                //         // for (int i = 0; i < data.length; i++) {
                //         //   if (i != index) {
                //         // data[i].isExpanded = false;
                //         // print('$i번 패널의 상태 : $isExpanded');
                //         //   }
                //         // }
                //         data[index].isExpanded = isExpanded;

                //         print('$index번 패널의 상태 : $isExpanded');
                //       });
                //     },
                //     children: data.map<ExpansionPanel>((Item item) {
                //       return ExpansionPanel(
                //         headerBuilder:
                //             (BuildContext context, bool isExpanded) {
                //           return ListTile(
                //             title: Text(item.headerValue),
                //           );
                //         },
                //         // body: Container(
                //         //   height: 300,
                //         //   decoration: const BoxDecoration(color: Colors.grey),
                //         //   child: Center(
                //         //     child: _buildVideoPlayer(item.replayUrl),
                //         //   ),
                //         // ),
                //         body: Container(
                //           height: 300,
                //           decoration: const BoxDecoration(color: Colors.grey),
                //         ),
                //         isExpanded: item.isExpanded,
                //       );
                //     }).toList(),
                //   )
                : const Center(
                    child: Text('다시보기 기록이 없습니다.'),
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
    this.isExpanded = false,
  });
  String expandedValue;
  String headerValue;
  bool isExpanded;
  String? replayUrl;
}

List<Item> generateItems(int numberOfItems) {
  print('generate items');
  List<String?> replayUrl = [];

  print('testList 길이 : ${CCTVReplayState.testList.length}');
  for (int i = 0; i < CCTVReplayState.testList.length; i++) {
    replayUrl.add(CCTVReplayState.testList[i]);
  }

  return List<Item>.generate(numberOfItems, (int index) {
    String replayTime = '';
    int replayTimestamp = 0;

    if (replayUrl[index] != null) {
      var tmp = replayUrl[index]!.split('-').last;
      replayTimestamp = int.parse(tmp.split('.').first);
      replayTime = DateTime.fromMillisecondsSinceEpoch(replayTimestamp * 1000)
          .toString();
    }

    return Item(
      headerValue: replayTime,
      expandedValue: 'This is item number $index',
      replayUrl: replayUrl[index],
      isExpanded: false,
    );
  });
}

Widget _buildVideoPlayer(String? videoUrl) {
  if (videoUrl != null) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
    CCTVReplayState.chewieControllers.add(chewieController);
    CCTVReplayState.videoControllers.add(videoPlayerController);

    return Chewie(controller: chewieController);
  } else {
    return const Text('다시보기 파일이 존재하지 않습니다.');
  }
}

class ExpansionPanelListExample extends StatefulWidget {
  const ExpansionPanelListExample({super.key, required this.datas});
  final List<dynamic> datas;

  @override
  State<ExpansionPanelListExample> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExample> {
  late final List<Item> _data = generateItems(widget.datas.length);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          for (int i = 0; i < _data.length; i++) {
            if (i != index) {
              _data[i].isExpanded = false;
            }
          }
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: Container(
            height: 300,
            decoration: const BoxDecoration(color: Colors.grey),
            child: _buildVideoPlayer(item.replayUrl), //List에 저장을 분리?
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
