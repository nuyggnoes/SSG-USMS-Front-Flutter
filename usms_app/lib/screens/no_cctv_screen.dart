import 'package:flutter/material.dart';

class NoCCTV extends StatefulWidget {
  const NoCCTV({super.key});

  @override
  State<NoCCTV> createState() => _NoCCTVState();
}

class _NoCCTVState extends State<NoCCTV> {
  final cctvNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/cctv_img.png',
              scale: 5,
            ),
            const Column(
              children: [
                Text(
                  '현재 매장에 등록된 CCTV가 존재하지 않습니다.',
                  style: TextStyle(fontWeight: FontWeight.w800),
                  softWrap: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'CCTV를 등록하여 서비스를 이용해보세요.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
