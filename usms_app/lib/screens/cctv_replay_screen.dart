import 'package:flutter/material.dart';

class CCTVReplay extends StatefulWidget {
  const CCTVReplay({super.key, required this.cctvId});
  final int cctvId;

  @override
  State<CCTVReplay> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CCTVReplay> {
  DateTime selectedDate = DateTime.now();

  final List<Item> _data = generateItems(24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CCTV 다시보기 ${widget.cctvId}'),
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
            onDateChanged: (DateTime date) {
              setState(() {
                selectedDate = date;
              });
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
                          child: Text('$selectedDate 동영상'),
                        )),
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
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      /// 헤더와 본문에 들어갈 내용
      headerValue: '$index시 ~ ${index + 1}시',
      expandedValue: 'This is item number $index',
    );
  });
}
