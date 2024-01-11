import 'package:flutter/material.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});
  static const route = 'store-detail';

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Detail',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {},
          ),
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text('매장 현황'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                      ),
                      width: 450,
                      height: 250,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                          ),
                          width: 145,
                          height: 96,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                          ),
                          width: 145,
                          height: 96,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                          ),
                          width: 145,
                          height: 96,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade400,
                      ),
                      width: 450,
                      height: 250,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade500,
                      ),
                      width: 450,
                      height: 250,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade600,
                      ),
                      width: 450,
                      height: 250,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
