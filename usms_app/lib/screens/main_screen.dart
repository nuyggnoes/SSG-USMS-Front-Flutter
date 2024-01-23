import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/store_detail_screen2.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/widget/store_register_widget.dart';
import 'package:usms_app/widget/test_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.uid});
  final uid;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<_MainScreenState> homeKey = GlobalKey<_MainScreenState>();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  final StoreService storeService = StoreService();
  late List<Store>? storeList;

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

  late List<Widget> widgetOptions;
  checkStoreState(int storeId) async {
    Store? store = await storeService.getStoreInfo(
        uid: widget.uid, storeId: storeId, context: context);

    switch (store!.store_state) {
      case 0:
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '반려',
              message: '반려상태',
              onPressed: () {
                print('반려반려');
              });
        });
        break;
      case 1:
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetail2(
                uid: widget.uid,
                storeId: storeId,
                storeInfo: store,
              ),
            ),
          );
        });
        break;
      case 2:
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '승인요청중',
              message: '승인 요청중',
              onPressed: () {
                print('승인요청중');
              });
        });
        break;
    }
  }

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
                  // FutureBuilder 사용, 카드 색 랜덤
                  // onTap callback함수 사용해서
                  // 반려, 승인요청, 승인상태에 따라 다른페이지로 route
                  Column(
                    children: [
                      FutureBuilder(
                        future: storeService.getUserStoresById(
                            uid: Provider.of<User>(context).uid!,
                            context: context),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            List<Store> storeList = snapshot.data!;
                            return SizedBox(
                              height: 400,
                              child: ListView.builder(
                                itemCount: storeList.length,
                                itemBuilder: (context, index) {
                                  Store store = storeList[index];
                                  return CurrencyCard(
                                    name: store.store_name,
                                    code: store.store_state,
                                    amount: '',
                                    icon: Icons.store_mall_directory_rounded,
                                    selectedCardColors: Colors.blue.shade200,
                                    animationController: _animationController,
                                    opacityAnimation: _opacityAnimation,
                                    onTapAction: () {
                                      // storeState 확인
                                      checkStoreState(store.store_id);
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      CurrencyCard(
                        name: 'GS25 무인매장점',
                        code: 0, // store_state : 승인(1) / 승인요청중(2) / 반려(0)
                        amount: '',
                        icon: Icons.store_mall_directory_rounded,
                        selectedCardColors: Colors.blue.shade200,
                        animationController: _animationController,
                        opacityAnimation: _opacityAnimation,
                        onTapAction: () {
                          // Navigator.pushNamed(context, Routes.storeDetail2,
                          //     arguments: widget.uid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreDetail2(
                                uid: widget.uid,
                                storeId: 1,
                                storeInfo: null,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CurrencyCard(
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
                    height: 30,
                  ),
                  RegisterStoreWidget(
                    uid: Provider.of<User>(context).uid!,
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
