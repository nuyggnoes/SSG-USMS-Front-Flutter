import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});
  static const route = 'store-detail';

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    String urlString = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
    Uri uri = Uri.parse(urlString);
    _controller = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

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
          elevation: 10,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
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
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(),
                            ),
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
