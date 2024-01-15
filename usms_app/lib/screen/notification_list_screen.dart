import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationListScreen extends StatefulWidget {
  static const route = 'notification-list-screen';
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

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
        centerTitle: true,
        elevation: 10,
      ),
      body: Center(
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
                        const Size(80, 60), // 높이와 너비를 조절할 수 있습니다.
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
                controller: _tabController,
                children: <Widget>[
                  makeListView(20),
                  makeListView(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
