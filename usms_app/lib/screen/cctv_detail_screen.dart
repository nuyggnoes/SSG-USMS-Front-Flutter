import 'package:flutter/material.dart';

class CCTVScreen extends StatefulWidget {
  static const route = 'cctv-screen';
  const CCTVScreen({super.key});

  @override
  State<CCTVScreen> createState() => _CCTVScreenState();
}

class _CCTVScreenState extends State<CCTVScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CCTV 현황'),
        ),
        body: const Center(
          child: Text('CCTV 현황'),
        ),
      ),
    );
  }
}
