import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tikidown/pages/player_page.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import 'dart:io' as io;

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  String directory = "";
  List file = [];
  List paths = [];
  var pathsObject = [];
  @override
  void initState() {
    super.initState();
    _myPath();
  }

  final path = '/storage/emulated/0/TikiDowns';

  _myPath() async {
    _listAll();
  }

  _listAll() async {
    var systemTempDir = Directory(path);
    await for (var entity
        in systemTempDir.list(recursive: true, followLinks: false)) {
      var type = entity.path.split('.').last;

      if (type == "jpg" || type == "jpeg" || type == "png") {
        paths.add(entity.path);
        pathsObject.add({"path": entity.path, "type": type});
      } else if (type == "mp4") {
        final uint8list = await VideoThumbnail.thumbnailData(
          video: entity.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128,
          quality: 100,
        );
        pathsObject
            .add({"path": entity.path, "type": type, "thumbnail": uint8list});
      }
    }

    _listofFiles();
  }

  void _listofFiles() async {
    setState(() {
      file = io.Directory(path).listSync();
    });

    // print(pathsObject);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, left: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(120),
                ),
                child: const Text(
                  "Downloads",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: width,
                height: height - 300,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pathsObject.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      width: width - 40,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 140,
                            height: 120,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Color(0xff7577CC),
                            ),
                            child: (pathsObject[index]["type"] == "jpg" ||
                                    pathsObject[index]["type"] == "jpeg" ||
                                    pathsObject[index]["type"] == "png")
                                ? Image.file(
                                    File(pathsObject[index]["path"]),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )
                                : Image.memory(
                                    pathsObject[index]["thumbnail"],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                            width: Get.width - 180,
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pathsObject[index]["type"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "username".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff7577CC),
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                          onPressed: () {
                                            Get.to(() => const PlayerPage(),
                                                arguments: pathsObject[index]);
                                          },
                                          icon: const Icon(Icons.play_arrow)),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff7577CC),
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                          onPressed: () {
                                            Share.shareXFiles([
                                              XFile(pathsObject[index]["path"])
                                            ]);
                                          },
                                          icon: const Icon(Icons.share)),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff7577CC),
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                          onPressed: () {
                                            File(pathsObject[index]["path"])
                                                .delete()
                                                .then(
                                                  (value) => Get.defaultDialog(
                                                      title: "Status",
                                                      middleText:
                                                          "Download success!",
                                                      backgroundColor:
                                                          Colors.teal,
                                                      titleStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      middleTextStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      radius: 30),
                                                );
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
