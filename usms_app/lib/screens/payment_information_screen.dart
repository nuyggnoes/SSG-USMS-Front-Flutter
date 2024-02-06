import 'package:flutter/material.dart';

class PayInfoScreen extends StatelessWidget {
  const PayInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제정보'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Text('유저의 결제 정보'),
          ),
        ),
      ),
    );
  }
}
