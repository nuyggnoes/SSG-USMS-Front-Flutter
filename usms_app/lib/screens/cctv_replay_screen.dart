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
  static List<ChewieController?> chewieControllers = [];
  static List<VideoPlayerController?> videoControllers = [];
  static List<dynamic> testList = [];

  final List<Item> _data = generateItems(24);

  @override
  initState() {
    selectedDate = DateTime.now();
    _fetchReplays();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   print('dispose()');
  //   for (var i = 0; i < videoList.length; i++) {
  //     print('dispose for()');
  //     videoList[i].dispose();
  //     if (chewieList[i] != null) {
  //       chewieList[i]!.dispose();
  //     }
  //   }
  //   super.dispose();
  // }

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
      print(returnValues);

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
                selectedDate = date;
                // 다시보기 api 요청
                // 각 패널에 영상 넣기
              });
              await _fetchReplays();
              // 다시보기 cctv 조회
            },
          ),
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
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
                  if (isExpanded) {
                    // CCTVService.getCCTVReplay(
                    //   context: context,
                    //   date: selectedDate,
                    //   index: index,
                    // ).then({});
                  }
                  if (_data.any((item) => item.isExpanded)) {
                    int openedPanelIndex =
                        _data.indexWhere((item) => item.isExpanded);
                    print(openedPanelIndex);
                    setState(() {
                      for (var item in _data) {
                        item.isExpanded = false;
                      }
                    });
                    print('$index번 패널의 상태 : $isExpanded');
                  }
                  setState(() {
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
                    // body: ListTile(
                    //   title: Text(item.headerValue),
                    //   subtitle: Text(item.expandedValue),
                    // ),
                    body: Container(
                      height: 200,
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: Center(
                        // child:
                        //     Text('${item.headerValue} ${item.replayUrl} 동영상'),
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
    this.isExpanded = false,
  });
  String expandedValue;
  String headerValue;
  bool isExpanded;
  String? replayUrl;
}

List<Item> generateItems(int numberOfItems) {
  List<String?> replayUrl = [];
  if (_CalendarScreenState.testList.length <= 24) {
    replayUrl = List<String?>.filled(24, null);
    for (int i = 0; i < _CalendarScreenState.testList.length; i++) {
      replayUrl[i] = _CalendarScreenState.testList[i];
    }
  }
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      /// 헤더와 본문에 들어갈 내용
      headerValue: '$index시 ~ ${index + 1}시',
      expandedValue: 'This is item number $index',
      replayUrl: replayUrl[index],
    );
  });
}

// void _disposeChewieControllers() {
//   for (var controller in chewieControllers) {
//     if (controller != null) {
//       controller.dispose();
//     }
//   }
// }

Widget _buildVideoPlayer(String? videoUrl) {
  print('패널의 url: $videoUrl');
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
