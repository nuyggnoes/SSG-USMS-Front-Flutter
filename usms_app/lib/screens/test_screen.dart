import 'dart:math';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> innerTextList = [
    'mainBox',
    'firstBox',
    'secondBox',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST SCREEN'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 여기서 출력
                  },
                  child: BoxWidget(innerTextList: innerTextList),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Text(innerTextList[1]),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Text(innerTextList[2]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

class BoxWidget extends StatelessWidget {
  const BoxWidget({
    super.key,
    required this.innerTextList,
  });

  final List<String> innerTextList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Text(innerTextList[0]),
    );
  }
}
