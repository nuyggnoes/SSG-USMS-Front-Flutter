import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/behavior_model.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/models/region_notification_model.dart';

import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/user_provider.dart';
import 'package:usms_app/widget/behavior_widget.dart';
import 'package:usms_app/widget/region_widget.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({
    super.key,
    required this.storeId,
    required this.cctvList,
  });
  final int storeId;
  final List<CCTV> cctvList;

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  // final Future<List<WordModel>> words = WordJson.getWords();
  // final Future<List<StoreNotification>> abnormalBehaviors =
  //     CCTVService.getAllBehaviorsByStore();
  late Future<List<StoreNotification>?> _behaviorsFuture;
  late Future<List<RegionNotification>?> _regionFuture;
  late Map<String, bool> filterButtonStates;

  DateTime? _startDate;
  DateTime? _endDate;
  List<String> paramList = [];
  List<StoreNotification> behaviors = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _startDate = null;
    _endDate = null;
    paramList = [];
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _behaviorsFuture = _fetchBehaviors();
    _regionFuture = _fetchRegions();
  }

  Future<List<StoreNotification>?> _fetchBehaviors() async {
    var returnValue = await StoreService.getAllBehaviorsByStore(
      context: context,
      storeId: widget.storeId,
      userId: Provider.of<UserProvider>(context, listen: false).user.id!,
      startDate: _startDate.toString().split(" ").first,
      endDate: _endDate.toString().split(" ").first,
      behaviorCodes: paramList,
    );
    print('allbehasviorByStore : $returnValue');
    return returnValue;
  }

  Future<List<RegionNotification>?> _fetchRegions() async {
    var returnValue = await StoreService.getRegionNotificationByStore(
      context: context,
      storeId: widget.storeId,
      userId: Provider.of<UserProvider>(context, listen: false).user.id!,
      startDate: _startDate.toString().split(" ").first,
      endDate: _endDate.toString().split(" ").first,
      behaviorCodes: paramList,
    );
    print('RegionReturnValue : $returnValue');
    return returnValue;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  bool isToggleOn = false;

  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지난 알림 목록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    text: "매장 알림 기록",
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
                            paramList = filterButtonStates.entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key)
                                .toList();
                            if (tabBarIndex == 0) {
                              _behaviorsFuture = _fetchBehaviors();
                            } else if (tabBarIndex == 1) {
                              _regionFuture = _fetchRegions();
                              setState(() {});
                            }
                            print('paramList : $paramList');
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
                  children: [
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
                        Expanded(
                          child: FutureBuilder(
                            future: _behaviorsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print('snapshot error');
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('매장 알림 기록이 없습니다.'),
                                  );
                                }
                                List<int> cctvIds = [];
                                List<String> cctvNames;
                                List<int> behaviorIds = [];

                                for (var snap in snapshot.data!) {
                                  cctvIds.add(snap.cctvId!);
                                  behaviorIds.add(snap.behaviorCode);
                                }
                                cctvNames = CCTV.cctvIdTocctvName(
                                    cctvIds, widget.cctvList);
                                List<String?> behaviorNames =
                                    behaviorIds.map((id) {
                                  return StoreService.reversedMap[id];
                                }).toList();

                                return ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 60),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var notification = snapshot.data![index];
                                    return Behavior(
                                      time: notification.eventTimestamp,
                                      // cctvName: notification.cctvId.toString(),
                                      cctvName: cctvNames[index],
                                      behavior: behaviorNames[index]!,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 20,
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
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
                        //     children: filterButtonStates.keys
                        //         .skip(2)
                        //         .map((String text) {
                        //       return buildToggleButton(text);
                        //     }).toList(),
                        //   ),
                        // ),
                        Expanded(
                          child: FutureBuilder(
                            future: _regionFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print('snapshot error');
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('지역 알림 기록이 없습니다.'),
                                  );
                                }
                                List<int> behaviorIds = [];

                                for (var snap in snapshot.data!) {
                                  behaviorIds.add(snap.behaviorCode);
                                }
                                List<String?> behaviorNames =
                                    behaviorIds.map((id) {
                                  return StoreService.reversedMap[id];
                                }).toList();

                                return ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var notification = snapshot.data![index];

                                    return Region(
                                      date: notification.date,
                                      count: notification.count,
                                      behavior: behaviorNames[index]!,
                                      region: notification.region!,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 20,
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
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
