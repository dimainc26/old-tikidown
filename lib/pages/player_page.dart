import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PlayerPage extends StatefulWidget {
  PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _controller;
  var data = Get.arguments;

  final String labelSign = "\u00A9 by TikiDowns";

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    if (data["type"] == "mp4") {
      _controller = VideoPlayerController.file(File(data["path"]))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _controller.play();
          });
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _sharePressed() async {
    // Share.shareXFiles([XFile(data["path"])], text: "${data["path"]}");
    await Share.shareXFiles([XFile("${data["path"]}")],
        text: "${data["path"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data["type"] == "jpg"
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(File(data["path"])))),
            )
          : Stack(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )),
                    child: _controller.value.isInitialized
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                  // duree totale ici
                                  Positioned(
                                    bottom: 20,
                                    child: Container(
                                      width: Get.width - 20,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        colors: const VideoProgressColors(
                                            playedColor: Colors.white,
                                            bufferedColor: Color(0xff7577CC)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 30),
                                width: Get.width - 100,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff7577CC),
                                      Color(0xff4E4E74)
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _controller.value.volume != 0
                                                ? _controller.setVolume(0)
                                                : _controller.setVolume(.6);
                                          });
                                        },
                                        icon: const Icon(Icons.volume_mute),
                                        color: Colors.white,
                                        iconSize: 45,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                          });
                                        },
                                        icon: Icon(_controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                        color: Colors.white,
                                        iconSize: 45,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await Share.shareXFiles(
                                              [XFile("${data["path"]}")],
                                              text: labelSign );
                                        },
                                        icon: const Icon(Icons.share),
                                        color: Colors.white,
                                        iconSize: 30,
                                      ),
                                    ]),
                              )
                            ],
                          )
                        : Container(),
                  ),
                )
              ],
            ),
    );
  }
}
