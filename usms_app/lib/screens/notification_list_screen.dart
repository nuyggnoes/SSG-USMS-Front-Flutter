import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usms_app/models/word_model.dart';
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
  final Future<List<WordModel>> words = WordJson.getWords();

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
  };

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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: filterButtonStates.keys.map((String text) {
                    //     return buildToggleButton(text);
                    //   }).toList(),
                    // ),
                    GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsets.all(8.0),
                      children: filterButtonStates.keys.map((String text) {
                        return buildToggleButton(text);
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    FutureBuilder(
                      future: words,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Expanded(
                                child: (ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 60),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var word = snapshot.data![index];
                                    return Word(
                                      eng: word.eng,
                                      kor: word.kor,
                                      id: word.id,
                                      day: word.day,
                                      isDone: word.isDone,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 20,
                                  ),
                                )),
                              ),
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    makeListView(20),
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
          // isToggleOn = !isToggleOn;
          filterButtonStates[buttonText] = !filterButtonStates[buttonText]!;
          print(filterButtonStates[buttonText]);
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
          // color: isToggleOn ? Colors.blue : Colors.white,
        ),
        child: Text(
          '#$buttonText',
          style: TextStyle(
            color: filterButtonStates[buttonText]! ? Colors.white : Colors.blue,
            // color: isToggleOn ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
}
