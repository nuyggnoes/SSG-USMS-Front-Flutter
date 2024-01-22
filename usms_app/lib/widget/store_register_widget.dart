import 'package:flutter/material.dart';
import 'package:usms_app/screens/register_store_screen.dart';
import 'package:usms_app/routes.dart';

class RegisterStoreWidget extends StatelessWidget {
  const RegisterStoreWidget({
    super.key,
    required int uid,
    required AnimationController animationController,
    required Animation<double> opacityAnimation,
    required Animation<Offset> offsetAnimation,
  })  : _animationController = animationController,
        _offsetAnimation = offsetAnimation,
        _opacityAnimation = opacityAnimation;

  final AnimationController _animationController;
  final Animation<double> _opacityAnimation;
  final Animation<Offset> _offsetAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _offsetAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 520,
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 170, 214, 211),
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
                        // color: Color.fromARGB(255, 130, 186, 182),
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
                                print('추가하기');
                                Navigator.pushNamed(
                                    context, Routes.registerStore);
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
