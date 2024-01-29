import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/utils/store_provider.dart';
import 'package:video_player/video_player.dart';

class ProviderTest extends StatefulWidget {
  const ProviderTest({super.key});

  @override
  State<ProviderTest> createState() => _ProviderTestState();
}

class _ProviderTestState extends State<ProviderTest> {
  String urlString1 =
      'https://usms.serveftp.com/video/hls/live/f6cddf98-777c-4bd5-9289-ce298bdd6140/index.m3u8';

  final List<String> urlStringList = [
    'https://usms.serveftp.com/video/hls/live/f6cddf98-777c-4bd5-9289-ce298bdd6140/index.m3u8',
  ];
  final List<VideoPlayerController> videoList = [];
  final List<ChewieController> chewieList = [];

  @override
  void dispose() {
    for (var i = 0; i < chewieList.length; i++) {
      videoList[i].dispose();
      chewieList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          List<Store> storeList = storeProvider.storeList;
          return Column(
            children: [
              Center(
                child: SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: storeList.length,
                    itemBuilder: (context, index) {
                      Store store = storeList[index];
                      return ListTile(
                        title: Text(store.name),
                        subtitle: Text(store.address),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
