import 'package:flutter/material.dart';

class SecurityLevel extends StatefulWidget {
  const SecurityLevel({super.key});
  static const route = "/security-level";

  @override
  State<SecurityLevel> createState() => _SecurityLevelState();
}

class _SecurityLevelState extends State<SecurityLevel> {
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
    return MaterialApp(
      title: 'Security Level',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.grey,
          size: 100,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 2,
          title: const Text('보안 레벨 설정'),
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 600,
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
                            width: 100,
                            height: 100,
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
                            width: 100,
                            height: 100,
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
                            width: 100,
                            height: 100,
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
                        width: 350,
                        height: 200,
                        child: Center(
                          child: Text(
                            "${securityMap[selectedIconIndex]}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 350,
                        height: 200,
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
                    minimumSize: const Size(350, 40),
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
        ),
      ),
    );
  }
}
