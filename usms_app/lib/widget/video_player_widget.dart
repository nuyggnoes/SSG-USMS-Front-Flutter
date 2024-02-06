import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:usms_app/models/cctv_model.dart';
import 'package:usms_app/screens/cctv_replay_screen.dart';
import 'package:usms_app/services/cctv_service.dart';
import 'package:usms_app/widget/custom_dialog.dart';

class ChewieListItem extends StatelessWidget {
  final ChewieController? chewieController;
  final int index;
  final String routes;
  final CCTV cctv;
  final int uid;
  final int storeId;

  const ChewieListItem({
    super.key,
    required this.chewieController,
    required this.index,
    required this.routes,
    required this.cctv,
    required this.uid,
    required this.storeId,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            cctv.isConnected && chewieController != null
                ? FutureBuilder(
                    future:
                        chewieController!.videoPlayerController.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return const SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Center(child: Text('동영상을 불러오지 못했습니다.')),
                        );
                      } else {
                        return SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Chewie(controller: chewieController!),
                        );
                      }
                    },
                  )
                : const SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Center(
                      child: Text('동영상이 연결되어있지 않습니다.'),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cctv.cctvName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('CCTV 삭제'),
                                  content: const Text('CCTV를 삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        '취소',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await CCTVService.deleteCCTV(
                                            context: context,
                                            uid: uid,
                                            storeId: storeId,
                                            cctvId: cctv.cctvId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                      child: const Text(
                                        '확인',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CCTVReplay(
                                  cctv: cctv, userId: uid, storeId: storeId),
                            ),
                          );
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      IconButton(
                        onPressed: () {
                          Future.microtask(() {
                            customShowDialog(
                                context: context,
                                btnText: '복사하기',
                                title: 'CCTV Stream Key값',
                                message: cctv.cctvStreamKey,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          });
                        },
                        icon: const Icon(Icons.key),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
