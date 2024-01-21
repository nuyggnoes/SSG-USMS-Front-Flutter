import 'package:flutter/material.dart';
import 'package:usms_app/service/routes.dart';
import 'package:usms_app/widget/store_register_widget.dart';
import 'package:usms_app/widget/test_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late RenderBox renderBox;

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails tapPosition) {
    renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
    });
  }

  _showContextMenu(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
        // Rect.fromPoints(
        //   renderBox.localToGlobal(_tapPosition),
        //   renderBox.localToGlobal(_tapPosition),
        // ).translate(0, 10),
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('매장 삭제'),
                  content: const Text('정말 삭제하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('매장 삭제'),
        ),
      ],
    );
  }

  late List<Widget> widgetOptions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // FutreBuilder 사용, 카드 색 랜덤
                  // onTap callback함수 사용해서
                  // 반려, 승인요청, 승인상태에 따라 다른페이지로 route
                  Column(
                    children: [
                      CurrencyCard(
                        name: 'GS25 무인매장점',
                        code: 0, // store_state : 승인(1) / 승인요청중(2) / 반려(0)
                        amount: '',
                        icon: Icons.store_mall_directory_rounded,
                        selectedCardColors: Colors.blue.shade200,
                        animationController: _animationController,
                        opacityAnimation: _opacityAnimation,
                        onTapAction: () {
                          Navigator.pushNamed(context, Routes.storeDetail2);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTapDown: (details) {
                          _getTapPosition(details);
                        },
                        onLongPress: () {
                          _showContextMenu(context);
                        },
                        child: CurrencyCard(
                          name: 'GS25 무인매장점2',
                          code: 1,
                          amount: '',
                          icon: Icons.storefront,
                          selectedCardColors: Colors.blue.shade300,
                          animationController: _animationController,
                          opacityAnimation: _opacityAnimation,
                          onTapAction: () {
                            Navigator.pushNamed(context, Routes.storeDetail);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CurrencyCard(
                        name: '신세계I&C 부산캠퍼스',
                        code: 2,
                        amount: '',
                        icon: Icons.filter_vintage_outlined,
                        selectedCardColors: Colors.red.shade400,
                        animationController: _animationController,
                        opacityAnimation: _opacityAnimation,
                        onTapAction: () {
                          Navigator.pushNamed(context, Routes.cctvReplay);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  RegisterStoreWidget(
                    animationController: _animationController,
                    offsetAnimation: _offsetAnimation,
                    opacityAnimation: _opacityAnimation,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
