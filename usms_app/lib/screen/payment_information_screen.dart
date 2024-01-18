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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.grey),
                  height: 400,
                  width: 400,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.amber),
                  height: 400,
                  width: 400,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.green),
                  height: 400,
                  width: 400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
