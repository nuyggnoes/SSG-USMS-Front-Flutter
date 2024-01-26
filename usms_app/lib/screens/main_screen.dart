import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';
import 'package:usms_app/routes.dart';
import 'package:usms_app/screens/store_detail_screen2.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/store_provider.dart';
import 'package:usms_app/utils/user_provider.dart';
import 'package:usms_app/widget/store_register_widget.dart';
import 'package:usms_app/widget/test_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<_MainScreenState> homeKey = GlobalKey<_MainScreenState>();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  final StoreService storeService = StoreService();

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

  setStoreProvider(Store storeProviders) {
    Provider.of<StoreProvider>(context).addStore(storeProviders);
  }

  checkStoreState(int storeId) async {
    Store? store = await storeService.getStoreInfo(
        uid: Provider.of<User>(context, listen: false).id!,
        storeId: storeId,
        context: context);
    print("is this null? => $store");

    switch (store!.storeState) {
      case 0:
        // Future.microtask(() {
        //   customShowDialog(
        //       context: context,
        //       title: '대기',
        //       message: '승인 대기 상태입니다.',
        //       onPressed: () {
        //         Navigator.pop(context);
        //       });
        // });
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetail2(
                uid: Provider.of<UserProvider>(context, listen: false).user.id,
                storeId: storeId,
                storeInfo: store,
              ),
            ),
          );
        });
        break;
      case 1:
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetail2(
                uid: Provider.of<UserProvider>(context).user.id,
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
              title: '승인 부적절',
              message: '${store.adminComment}',
              onPressed: () {
                print('승인 부적절');
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
                        future: storeService.getStoresByUserId(
                            uid: Provider.of<User>(context).id!,
                            context: context),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('에러 발생: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null) {
                            List<Store> storeList = snapshot.data!;
                            // setStoreProvider(snapshot.data!);
                            // 1. 리스트를 한번에 Provider로 업데이트(아직 구현 안함)
                            return SizedBox(
                              height: 400,
                              child: ListView.builder(
                                itemCount: storeList.length,
                                itemBuilder: (context, index) {
                                  Store store = storeList[index];
                                  // setStoreProvider(store);
                                  //2. ListView를 생성할때 Store 각각을 StoreList.add() 를 통해 업데이트

                                  return CurrencyCard(
                                    name: store.name,
                                    code: store.storeState,
                                    amount: '',
                                    icon: Icons.store_mall_directory_rounded,
                                    selectedCardColors: Colors.blue.shade200,
                                    animationController: _animationController,
                                    opacityAnimation: _opacityAnimation,
                                    onTapAction: () {
                                      checkStoreState(store.id!);
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            print('${snapshot.hasData}');
                            print('${snapshot.data}');
                            print('else');
                            return Container();
                          }
                        }),
                      ),
                      // storeState : READY(0), APPROVAL(1), DISAPPROVAL(2), STOPPED(3);
                      CurrencyCard(
                        name: 'GS25 무인매장점',
                        code: 0,
                        amount: '',
                        icon: Icons.store_mall_directory_rounded,
                        selectedCardColors: Colors.blue.shade200,
                        animationController: _animationController,
                        opacityAnimation: _opacityAnimation,
                        onTapAction: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.storeDetail2,
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreDetail2(
                                uid: Provider.of<UserProvider>(context).user.id,
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
                    uid: Provider.of<User>(context).id!,
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
