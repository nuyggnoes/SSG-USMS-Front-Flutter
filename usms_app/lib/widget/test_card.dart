import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, amount;
  final IconData icon;
  final int code;
  // final bool isInverted;

  // final _blackColor = const Color(0xFF1F2123);
  Color selectedCardColors;
  final AnimationController animationController;
  final Animation<double> opacityAnimation;

  CurrencyCard({
    super.key,
    required this.name,
    required this.code,
    required this.amount,
    required this.icon,
    required this.selectedCardColors,
    required this.animationController,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    String storeStateText = '';
    Color? stateTextColor;

    switch (code) {
      case 1:
        storeStateText = '';
        stateTextColor = null;
        break;
      case 2:
        storeStateText = '승인 요청 중';
        stateTextColor = Colors.black.withOpacity(0.5);
      case 0:
        storeStateText = '반려';
        stateTextColor = Colors.red.withOpacity(0.8);
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return (Opacity(
          opacity: opacityAnimation.value,
          child: Container(
            // 컨테이너 밖으로 튀어나온 아이콘 잘라줌
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: selectedCardColors,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            amount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            storeStateText,
                            style: TextStyle(
                              // color: Colors.white.withOpacity(0.8),
                              color: stateTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 2.2,
                    child: Transform.translate(
                      offset: const Offset(-7, 13),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 85,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
