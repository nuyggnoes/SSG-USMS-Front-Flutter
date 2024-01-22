import 'package:flutter/material.dart';

class CCTVScreen extends StatefulWidget {
  static const route = 'cctv-screen';
  const CCTVScreen({super.key});

  @override
  State<CCTVScreen> createState() => _CCTVScreenState();
}

class _CCTVScreenState extends State<CCTVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV 현황'),
        elevation: 10,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                height: 380,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('매장 입구'),
                          subtitle: Text('CCTV 1'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('진열대1'),
                          subtitle: Text('CCTV 2'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('진열대2'),
                          subtitle: Text('CCTV 3'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('진열대3'),
                          subtitle: Text('CCTV 4'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('진열대4'),
                          subtitle: Text('CCTV 5'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7.0,
                        child: const ListTile(
                          title: Text('창고'),
                          subtitle: Text('CCTV 6'),
                          leading: Icon(Icons.camera),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
