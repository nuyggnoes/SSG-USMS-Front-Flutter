import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usms_app/models/behavior_model.dart';
import 'package:usms_app/models/word_model.dart';
import 'package:usms_app/services/cctv_service.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/services/word_json.dart';
import 'package:usms_app/widget/word_widget.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  // final Future<List<WordModel>> words = WordJson.getWords();
  // final Future<List<BehaviorModel>> abnormalBehaviors =
  //     CCTVService.getAllBehaviorsByStore();
  // 매장 알림이면 매장 아이디가 필요한게 아니라 userId만 있으면 되는거 아닌가.

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ListView makeListView(int cnt) {
    return ListView(
      children: List.generate(
        cnt,
        (index) => ListTile(
          title: Text('Item ${index + 1}'),
        ),
      ),
    );
  }

  bool isToggleOn = false;

  Map<String, bool> filterButtonStates = {
    '입실': false,
    '퇴실': false,
    '폭행, 싸움': false,
    '절도, 강도': false,
    '기물 파손': false,
    '실신': false,
    '투기': false,
    '주취행동': false,
  };
  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지난 알림 목록'),
        leading: const Icon(Icons.notifications),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TabBar(
                onTap: (value) {
                  tabBarIndex = value;
                  print(value);
                  setState(() {
                    filterButtonStates = {
                      '입실': false,
                      '퇴실': false,
                      '폭행, 싸움': false,
                      '절도, 강도': false,
                      '기물 파손': false,
                      '실신': false,
                      '투기': false,
                      '주취행동': false,
                    };
                  });
                },
                indicatorColor: Colors.blueAccent,
                controller: _tabController,
                labelColor: Colors.black54,
                unselectedLabelColor: Colors.black54,
                tabs: const <Widget>[
                  Tab(
                    text: "개인 알림 기록",
                  ),
                  Tab(
                    text: "업주 긴급 알림",
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              side: const MaterialStatePropertyAll(
                                BorderSide(color: Colors.grey),
                              ),
                              fixedSize: MaterialStateProperty.all(
                                const Size(80, 50),
                              ),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                locale: const Locale('ko', 'KR'),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _startDate = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _startDate == null
                                  ? ''
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_startDate!),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                          child: Text(' -- '),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              side: const MaterialStatePropertyAll(
                                BorderSide(color: Colors.grey),
                              ),
                              fixedSize: MaterialStateProperty.all(
                                const Size(80, 50),
                              ),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                locale: const Locale('ko', 'KR'),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _endDate = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _endDate == null
                                  ? ''
                                  : DateFormat('yyyy-MM-dd').format(_endDate!),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                              BorderSide(color: Colors.grey),
                            ),
                            fixedSize: MaterialStateProperty.all(
                              const Size(80, 50),
                            ),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {
                            String startDateString;
                            String endtDateString;
                            startDateString =
                                _startDate.toString().split(" ").first;
                            endtDateString =
                                _endDate.toString().split(" ").first;
                            print('[SELECT DATE] : $_startDate ~ $_endDate');
                            print(
                                '[SELECT DATE] : $startDateString,$endtDateString');

                            print('tabbarIndex = $tabBarIndex');
                            if (tabBarIndex == 0) {
                              for (var entry in filterButtonStates.entries) {
                                if (entry.value == true) {
                                  print('개인 알림 기록 Category: ${entry.key}');
                                }
                              }
                            } else {
                              for (var entry in filterButtonStates.entries) {
                                if (entry.value == true) {
                                  print('업주 긴급 알림 Category: ${entry.key}');
                                }
                              }
                            }
                          },
                          child: const Text(
                            '조회',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: 100,
                    //   child: GridView.count(
                    //     crossAxisCount: 4,
                    //     mainAxisSpacing: 8,
                    //     crossAxisSpacing: 8,
                    //     shrinkWrap: true,
                    //     childAspectRatio: 3 / 1,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     padding: const EdgeInsets.all(8.0),
                    //     children: filterButtonStates.keys.map((String text) {
                    //       return buildToggleButton(text);
                    //     }).toList(),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: GridView.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            shrinkWrap: true,
                            childAspectRatio: 3 / 1,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            children:
                                filterButtonStates.keys.map((String text) {
                              return buildToggleButton(text);
                            }).toList(),
                          ),
                        ),
                        // Expanded(
                        //   child: FutureBuilder(
                        //     // future: words,
                        //     future: StoreService.getAllBehaviorsByStore(),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.hasError) {
                        //         return Center(
                        //             child: Text('에러 발생: ${snapshot.error}'));
                        //       } else if (snapshot.hasData) {
                        //         return Column(
                        //           children: [
                        //             Expanded(
                        //               child: ListView.separated(
                        //                 shrinkWrap: true,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     vertical: 10, horizontal: 60),
                        //                 itemCount: snapshot.data!.length,
                        //                 itemBuilder: (context, index) {
                        //                   print(
                        //                       '길이 : ${snapshot.data!.length}');
                        //                   var word = snapshot.data![index];
                        //                   return const Word(
                        //                     eng: 'word.eng',
                        //                     kor: 'word.kor',
                        //                     id: 1,
                        //                     day: 1,
                        //                     isDone: true,
                        //                   );
                        //                 },
                        //                 separatorBuilder: (context, index) =>
                        //                     const SizedBox(
                        //                   height: 20,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         );
                        //       } else if (!snapshot.hasData ||
                        //           (snapshot.data as List).isEmpty) {
                        //         return const Center(
                        //             child: Text('알림 기록이 없습니다.'));
                        //       } else {
                        //         return const CircularProgressIndicator();
                        //       }
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: GridView.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            shrinkWrap: true,
                            childAspectRatio: 3 / 1,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            children: filterButtonStates.keys
                                .skip(2)
                                .map((String text) {
                              return buildToggleButton(text);
                            }).toList(),
                          ),
                        ),
                        Expanded(child: makeListView(20)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleButton(String buttonText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterButtonStates[buttonText] = !filterButtonStates[buttonText]!;
          print('$buttonText 의 상태 : ${filterButtonStates[buttonText]}');
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(40),
          color: filterButtonStates[buttonText]! ? Colors.blue : Colors.white,
        ),
        child: Text(
          '#$buttonText',
          style: TextStyle(
            color: filterButtonStates[buttonText]! ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
}
