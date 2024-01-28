import 'package:flutter/material.dart';

class CCTVManual extends StatelessWidget {
  const CCTVManual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('CCTV 설치방법'),
        ),
      ),
    );
  }
}
