import 'package:flutter/material.dart';
import 'package:usms_app/screens/register_store_screen.dart';

class RegisterStoreWidget extends StatelessWidget {
  const RegisterStoreWidget({
    super.key,
    required this.uid,
    required this.animationController,
    required this.opacityAnimation,
    required this.offsetAnimation,
  });
  final int uid;
  final AnimationController animationController;
  final Animation<double> opacityAnimation;
  final Animation<Offset> offsetAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: offsetAnimation,
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 520,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          '서비스 ',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '시작하기',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/main_img.png',
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '서비스를 이용하기 위해 매장을 추가해주세요.',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterStore(uid: uid),
                                  ),
                                );
                              },
                              child: const Text(
                                '추가',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
