import 'package:flutter/material.dart';

class AdSlider extends StatelessWidget {
  AdSlider({super.key});
  final List<String> ads = [
    "제품 프로모션 1",
    "제품 프로모션 2",
    "제품 프로모션 3",
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          // color: Colors.amber,
          // decoration: const BoxDecoration(
          //   border: Border(
          //       bottom: BorderSide(color: Colors.black),
          //       right: BorderSide(color: Colors.black)),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(15),
          //   ),
          // ),
          child: Column(
            children: [
              // Text(
              //   ads[index],
              //   style: const TextStyle(fontSize: 24, color: Colors.black),
              // ),
              // const Expanded(
              //   child: Icon(
              //     Icons.abc,
              //     size: 80,
              //   ),
              // ),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //   width: double.infinity,
              //   child: Text('${index + 1}/${ads.length}'),
              // ),
              Image.asset(
                'assets/promotion1.png',
              ),
            ],
          ),
        );
      },
    );
  }
}
