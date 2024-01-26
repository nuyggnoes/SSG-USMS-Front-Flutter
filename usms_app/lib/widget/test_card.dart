import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, amount;
  final IconData icon;
  final int code;
  // final bool isInverted;

  // final _blackColor = const Color(0xFF1F2123);
  final Color selectedCardColors;
  final AnimationController animationController;
  final Animation<double> opacityAnimation;
  void Function()? onTapAction;

  CurrencyCard({
    super.key,
    required this.name,
    required this.code,
    required this.amount,
    required this.icon,
    required this.selectedCardColors,
    required this.animationController,
    required this.opacityAnimation,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    String storeStateText = '';
    Color? stateTextColor;

    switch (code) {
      case 0:
        storeStateText = '승인 요청 중';
        stateTextColor = Colors.black.withOpacity(0.5);
      // onTapAction = () {
      //   customShowDialog(
      //       context: context,
      //       title: '승인 요청 중',
      //       message: '승인 요청 중입니다. 잠시만 기다려주세요.',
      //       onPressed: () {
      //         Navigator.pop(context);
      //       });
      // };
      case 1:
        storeStateText = '';
        stateTextColor = null;
        // onTapAction = () {
        //   Navigator.pushNamed(context, Routes.storeDetail2);
        // };
        break;
      case 2:
        storeStateText = '반려';
        stateTextColor = Colors.red.withOpacity(0.8);
      // onTapAction = () {
      //   customShowDialog(
      //       context: context,
      //       title: '반려',
      //       message: '반려이유',
      //       onPressed: () {
      //         Navigator.pop(context);
      //       });
      // };
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return (Opacity(
          opacity: opacityAnimation.value,
          child: GestureDetector(
            onTap: onTapAction,
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
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                    ),
                    Expanded(
                      flex: 1,
                      child: Transform.scale(
                        scale: 2,
                        child: Transform.translate(
                          offset: const Offset(1, 13),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}
