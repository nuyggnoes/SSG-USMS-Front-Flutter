import 'package:flutter/material.dart';

class TestSecurity extends StatefulWidget {
  const TestSecurity({super.key});

  @override
  State<TestSecurity> createState() => _TestSecurityState();
}

class _TestSecurityState extends State<TestSecurity> {
  Color security0 = Colors.grey;
  Color security1 = Colors.grey;
  Color security2 = Colors.grey;
  Color descriptColor = Colors.grey;

  bool _onTab = false;
  int selectedIconIndex = -1;
  Map<int, String> securityMap = {
    0: '아무런 추가 보안 사항이 없습니다.',
    1: '로그인 시 SMS 알림이 전송됩니다.',
    2: '2차 비밀번호를 사용할 수 있습니다.',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 420,
        width: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _onTab = true;
                      selectedIconIndex = 0;
                      security0 = Colors.red.shade400;
                      security1 = Colors.grey;
                      security2 = Colors.grey;
                      descriptColor = security0;
                      print(selectedIconIndex);
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        // width: 100,
                        // height: 100,
                        child: Icon(
                          Icons.gpp_bad_outlined,
                          color: security0,
                        ),
                      ),
                      const Text('0레벨'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _onTab = true;
                      selectedIconIndex = 1;
                      security0 = Colors.grey;
                      security1 = Colors.amber;
                      security2 = Colors.grey;
                      descriptColor = security1;
                      print(selectedIconIndex);
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        // width: 100,
                        // height: 100,
                        child: Icon(
                          Icons.health_and_safety_outlined,
                          color: security1,
                        ),
                      ),
                      const Text('1레벨'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _onTab = true;
                      selectedIconIndex = 2;
                      security0 = Colors.grey;
                      security1 = Colors.grey;
                      security2 = Colors.green;
                      descriptColor = security2;
                      print(selectedIconIndex);
                      print(securityMap[selectedIconIndex]);
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        // width: 100,
                        // height: 100,
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: security2,
                        ),
                      ),
                      const Text('2레벨'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _onTab
                ? Container(
                    decoration: BoxDecoration(
                      color: descriptColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: descriptColor,
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        "${securityMap[selectedIconIndex]}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 40,
                    height: 40,
                  ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                print('btn clicked');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                // minimumSize: const Size(350, 40),
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
