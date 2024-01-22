import 'package:flutter/material.dart';

class TestTest extends StatefulWidget {
  const TestTest({super.key});

  @override
  State<TestTest> createState() => _TestTestState();
}

class _TestTestState extends State<TestTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Test Screen'),
      ),
      body: const Center(
        child: Text('hi'),
      ),
    );
  }
}
