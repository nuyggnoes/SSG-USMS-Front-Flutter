import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';

// screen
import 'package:usms_app/screens/main_screen.dart';
import 'package:usms_app/screens/user_info_screen.dart';
import 'package:usms_app/services/user_service.dart';
import 'package:usms_app/utils/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  final UserService userService = UserService();
  late int? uid;

  late User? user;
  late Store store;
  late List<Widget> widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    try {
      userService.getUserInfo().then((value) {
        setState(() {
          widgetOptions = <Widget>[
            const MainScreen(),
            const MyPageScreen(),
          ];
          user = value;
          Provider.of<UserProvider>(context, listen: false).updateUser(value!);
          uid = user!.id;
        });
      });
    } catch (e) {
      //error
    }
  }

  int currentPageIndex = 0;
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => user,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 50,
            width: 250,
            child: Image.asset(
              'assets/usmslogo1.png',
              fit: BoxFit.fill,
            ),
          ),
          centerTitle: true,
          surfaceTintColor: Colors.white,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '내 정보',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue[400],
          iconSize: 37,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
        body: SafeArea(
          child: widgetOptions.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: widgetOptions.elementAt(selectedIndex),
                ),
        ),
      ),
    );
  }
}
