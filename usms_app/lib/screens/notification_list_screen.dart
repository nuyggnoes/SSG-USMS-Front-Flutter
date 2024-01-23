import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/models/word_model.dart';
import 'package:usms_app/services/word_json.dart';
import 'package:usms_app/widget/word_widget.dart';

class NotificationListScreen extends StatefulWidget {
  static const route = 'notification-list-screen';
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
                child: Row(
                  children: [
                    Expanded(
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        dateFormat: DateFormat.yMd(),
                        decoration: const InputDecoration(
                          labelText: '날짜를 선택해주세요.',
                        ),
                        firstDate: DateTime.utc(2022),
                        lastDate: DateTime.now(),
                        onChanged: (DateTime? value) {
                          setState(() {
                            _startDate = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      child: Text('~'),
                    ),
                    Expanded(
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        dateFormat: DateFormat.yMd(),
                        decoration: const InputDecoration(
                          labelText: '날짜를 선택해주세요.',
                        ),
                        firstDate: DateTime.utc(2022),
                        lastDate: DateTime.now(),
                        onChanged: (DateTime? value) {
                          _endDate = value;
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        side: const MaterialStatePropertyAll(
                          BorderSide(color: Colors.grey),
                        ),
                        fixedSize: MaterialStateProperty.all(
                          const Size(80, 60),
                        ),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        print('[SELECT DATE] : $_startDate ~ $_endDate');
                      },
                      child: const Text(
                        '조회',
                        style: TextStyle(color: Colors.black),
                      ),
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
}
