import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({super.key});
  static const route = 'store-detail';

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    setVideoPlayer();
  }

  setVideoPlayer() async {
    String urlString = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
    Uri uri = Uri.parse(urlString);
    // _videoController = VideoPlayerController.networkUrl(uri)
    //   ..initialize().then((_) {
    //     setState(() {
    //       _videoController.play();
    //     });
    //   });
    _videoController = VideoPlayerController.networkUrl(uri);
    await _videoController.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        aspectRatio: 16 / 9,
      );
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
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
                      // child: _videoController.value.isInitialized
                      //     ? AspectRatio(
                      //         aspectRatio: _videoController.value.aspectRatio,
                      //         child: VideoPlayer(_videoController),
                      //       )
                      //     : const Center(
                      //         child: CircularProgressIndicator(),
                      //       ),
                      child: _videoController.value.isInitialized
                          ? Chewie(controller: _chewieController)
                          : const Center(
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
