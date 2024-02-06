import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';

import 'package:usms_app/screens/store_detail_screen.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/store_provider.dart';
import 'package:usms_app/utils/user_provider.dart';
import 'package:usms_app/widget/store_register_widget.dart';
import 'package:usms_app/widget/store_card.dart';

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

  checkStoreState(int storeId) async {
    Store? store = await StoreService.getStoreInfo(
        uid: Provider.of<User>(context, listen: false).id!,
        storeId: storeId,
        context: context);

    switch (store!.storeState) {
      case 0:
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '승인 대기',
              message: '해당 매장은 관리자 승인 대기 상태입니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        break;
      case 1:
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetail(
                uid: Provider.of<UserProvider>(context, listen: false).user.id,
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
                Navigator.pop(context);
              });
        });
        break;
    }
  }

  double listViewHeightCalculation(int storeListLength) {
    double cardHeight = 150.0;
    double totalHeight = cardHeight * storeListLength;
    return totalHeight;
  }

  Color getRandomColor() {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }

  IconData getRandomIconData() {
    List<IconData> randomIconData = [
      Icons.store_mall_directory_rounded,
      Icons.storefront_outlined,
      Icons.apartment_rounded,
    ];
    return randomIconData[Random().nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    var height = 150.0;

    return Scaffold(
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
                  Column(
                    children: [
                      FutureBuilder(
                        future: storeService.getStoresByUserId(
                            uid: Provider.of<User>(context).id!,
                            context: context),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: 400,
                              child: const SpinKitWave(
                                color: Colors.blueAccent,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('에러 발생: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null) {
                            return const SizedBox();
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      Consumer<StoreProvider>(
                        builder: (context, storeProvider, _) {
                          List<Store> storeList = storeProvider.storeList;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    listViewHeightCalculation(storeList.length),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  itemCount: storeList.length,
                                  itemBuilder: (context, index) {
                                    height = height * storeList.length;
                                    Store store = storeList[index];
                                    return Column(
                                      children: [
                                        CurrencyCard(
                                          name: store.name,
                                          code: store.storeState,
                                          amount: '',
                                          icon: getRandomIconData(),
                                          selectedCardColors:
                                              Colors.blue.shade200,
                                          animationController:
                                              _animationController,
                                          opacityAnimation: _opacityAnimation,
                                          onTapAction: () {
                                            checkStoreState(store.id!);
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
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
