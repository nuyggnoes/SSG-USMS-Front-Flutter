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
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            color: Colors.amber[100], // 각 페이지의 배경색을 설정할 수 있습니다.
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    ads[index],
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  width: double.infinity,
                  child: Text('${index + 1}/${ads.length}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
