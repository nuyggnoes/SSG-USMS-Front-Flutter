import 'package:flutter/material.dart';

class CCTVManual extends StatelessWidget {
  const CCTVManual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV 설치 가이드'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Image.asset('assets/stream_manual1.jpg'),
              Image.asset('assets/stream_manual2.jpg'),
            ],
          )),
        ),
      ),
    );
  }
}
