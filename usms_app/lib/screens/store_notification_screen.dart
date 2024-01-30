// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:usms_app/models/behavior_model.dart';

// import 'package:usms_app/services/store_service.dart';
// import 'package:usms_app/utils/user_provider.dart';
// import 'package:usms_app/widget/behavior_widget.dart';

// class StoreNotification extends StatefulWidget {
//   const StoreNotification({
//     super.key,
//     required this.storeId,
//     required this.cctv,
//   });
//   final storeId;
//   final cctv;

//   @override
//   State<StoreNotification> createState() => _StoreNotificationState();
// }

// // final Future<List<StoreNotification>> abnormalBehaviors =
// //     CCTVService.getAllBehaviorsByStore();

// DateTime? _startDate;
// DateTime? _endDate;

// late Map<String, bool> filterButtonStates;

// List<String> paramList = [];
// List<StoreNotification> behaviors = [];

// class _StoreNotificationState extends State<StoreNotification> {
//   late Future<List<StoreNotification>> _behaviorsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _startDate = null;
//     _endDate = null;
//     paramList = [];
//     filterButtonStates = {
//       '입실': false,
//       '퇴실': false,
//       '폭행, 싸움': false,
//       '절도, 강도': false,
//       '기물 파손': false,
//       '실신': false,
//       '투기': false,
//       '주취행동': false,
//     };
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _behaviorsFuture = _fetchBehaviors();
//   }

//   Future<List<StoreNotification>> _fetchBehaviors() async {
//     return await StoreService.getAllBehaviorsByStore(
//       context: context,
//       storeId: widget.storeId,
//       userId: Provider.of<UserProvider>(context, listen: false).user.id!,
//       startDate: _startDate.toString().split(" ").first,
//       endDate: _endDate.toString().split(" ").first,
//       behaviorCodes: paramList,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('매장별 알림 기록'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         side: const MaterialStatePropertyAll(
//                           BorderSide(color: Colors.grey),
//                         ),
//                         fixedSize: MaterialStateProperty.all(
//                           const Size(80, 50),
//                         ),
//                         shape: MaterialStateProperty.all(
//                           const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero,
//                           ),
//                         ),
//                       ),
//                       onPressed: () async {
//                         final selectedDate = await showDatePicker(
//                           context: context,
//                           initialDate: _startDate,
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime.now(),
//                           locale: const Locale('ko', 'KR'),
//                         );
//                         if (selectedDate != null) {
//                           setState(() {
//                             _startDate = selectedDate;
//                           });
//                         }
//                       },
//                       child: Text(
//                         _startDate == null
//                             ? ''
//                             : DateFormat('yyyy-MM-dd').format(_startDate!),
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                     child: Text(' -- '),
//                   ),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         side: const MaterialStatePropertyAll(
//                           BorderSide(color: Colors.grey),
//                         ),
//                         fixedSize: MaterialStateProperty.all(
//                           const Size(80, 50),
//                         ),
//                         shape: MaterialStateProperty.all(
//                           const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero,
//                           ),
//                         ),
//                       ),
//                       onPressed: () async {
//                         final selectedDate = await showDatePicker(
//                           context: context,
//                           initialDate: _endDate,
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime.now(),
//                           locale: const Locale('ko', 'KR'),
//                         );
//                         if (selectedDate != null) {
//                           setState(() {
//                             _endDate = selectedDate;
//                           });
//                         }
//                       },
//                       child: Text(
//                         _endDate == null
//                             ? ''
//                             : DateFormat('yyyy-MM-dd').format(_endDate!),
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       side: const MaterialStatePropertyAll(
//                         BorderSide(color: Colors.grey),
//                       ),
//                       fixedSize: MaterialStateProperty.all(
//                         const Size(80, 50),
//                       ),
//                       shape: MaterialStateProperty.all(
//                         const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero,
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         paramList = [];
//                         // for (var entry in filterButtonStates.entries) {
//                         //   if (entry.value == true) {
//                         //     print('매장별 알림 기록 Category: ${entry.key}');
//                         //     paramList.add(entry.key);
//                         //   }
//                         // }
//                         paramList = filterButtonStates.entries
//                             .where((entry) => entry.value)
//                             .map((entry) => entry.key)
//                             .toList();
//                         print(paramList);

//                         _behaviorsFuture = _fetchBehaviors();
//                       });
//                     },
//                     child: const Text(
//                       '조회',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 height: 120,
//                 child: GridView.count(
//                   crossAxisCount: 4,
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                   childAspectRatio:
//                       (MediaQuery.of(context).size.width / 4) / 50,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(8.0),
//                   children: filterButtonStates.keys.map((String text) {
//                     return buildToggleButton(text);
//                   }).toList(),
//                 ),
//               ),
//               Expanded(
//                 child: FutureBuilder(
//                   // future: StoreService.getAllBehaviorsByStore(
//                   //   storeId: widget.storeId,
//                   //   userId: Provider.of<UserProvider>(context).user.id!,
//                   //   startDate: _startDate.toString().split(" ").first,
//                   //   endDate: _endDate.toString().split(" ").first,
//                   //   behaviorCodes: paramList,
//                   // ),
//                   future: _behaviorsFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return Center(child: Text('에러 발생: ${snapshot.error}'));
//                     } else if (snapshot.hasData) {
//                       return ListView.separated(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 60),
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (context, index) {
//                           var notification = snapshot.data![index];
//                           return null;
//                           // return Behavior(
//                           //   time: notification.time,
//                           //   cctvName: notification.cctvName,
//                           //   behaviorCode: notification.behaviorCode,
//                           // );
//                         },
//                         separatorBuilder: (context, index) => const SizedBox(
//                           height: 20,
//                         ),
//                       );
//                     } else if (!snapshot.hasData ||
//                         (snapshot.data as List).isEmpty) {
//                       return const Center(child: Text('알림 기록이 없습니다.'));
//                     } else {
//                       return const CircularProgressIndicator();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildToggleButton(String buttonText) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           filterButtonStates[buttonText] = !filterButtonStates[buttonText]!;
//           print('$buttonText 의 상태 : ${filterButtonStates[buttonText]}');
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.blue,
//             width: 2.0,
//           ),
//           borderRadius: BorderRadius.circular(40),
//           color: filterButtonStates[buttonText]! ? Colors.blue : Colors.white,
//         ),
//         child: Text(
//           '#$buttonText',
//           style: TextStyle(
//             color: filterButtonStates[buttonText]! ? Colors.white : Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }
// }
