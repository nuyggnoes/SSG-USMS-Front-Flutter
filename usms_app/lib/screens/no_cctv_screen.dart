import 'package:flutter/material.dart';
import 'package:usms_app/widget/ad_slider.dart';
import 'package:usms_app/widget/custom_textFormField.dart';

class NoCCTV extends StatefulWidget {
  const NoCCTV({super.key});

  @override
  State<NoCCTV> createState() => _NoCCTVState();
}

class _NoCCTVState extends State<NoCCTV> {
  final _formKey = GlobalKey<FormState>();
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
              // width: double.infinity,
              scale: 5,
            ),
            const Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            // ExpansionTile(
            //   title: const Text('CCTV 추가하기'),
            //   children: [
            //     SizedBox(
            //       width: double.infinity,
            //       height: 100,
            //       child: AdSlider(),
            //     ),
            //     Form(
            //       key: _formKey,
            //       child: Column(
            //         children: [
            //           CustomTextFormField(
            //             textController: cctvNameController,
            //             textType: TextInputType.text,
            //             labelText: 'CCTV 별칭',
            //             validator: (value) {
            //               if (value!.isEmpty) {
            //                 return 'CCTV 별칭을 입력해주세요.';
            //               }
            //               return null;
            //             },
            //           ),
            //           ElevatedButton(
            //             onPressed: () {
            //               if (_formKey.currentState?.validate() ?? false) {
            //                 print('빈칸 없음');
            //               }
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.blueAccent,
            //             ),
            //             child: const Text(
            //               'CCTV 추가하기',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.w900,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
