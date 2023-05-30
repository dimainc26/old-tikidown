import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Neo extends StatefulWidget {
  Neo({Key? key}) : super(key: key);

  @override
  State<Neo> createState() => _NeoState();
}

class _NeoState extends State<Neo> {
  bool loading = false;
  Dio dio = Dio();
  double progress = 0.0;

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> saveFile(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          String newPath = "";

          List<String> folders = directory!.path.split("/");

          for (int i = 0; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }

          newPath = newPath + "/TikiDowns";
          directory = Directory(newPath);

          print(directory.path);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      print(directory);

      if (!await directory.exists()) {
        print("1 ici --- object");
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        File saveFile = File(directory.path + "/${fileName}");
        await dio.download(url, saveFile.path,
            onReceiveProgress: (download, totalSize) {
          setState(() {
            progress = download / totalSize;
          });
        });

        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(
        "https://v39-as.tiktokcdn.com/b0ad553434547dd5d4352220f4509df4/64752085/video/tos/useast2a/tos-useast2a-pve-0037c001-aiso/oIHE1dg78e6iABPg6kLGRLQ77DQ1bDGnIof5Dh/?a=1233&ch=0&cr=3&dr=0&lr=all&cd=0%7C0%7C0%7C3&cv=1&br=2836&bt=1418&cs=0&ds=6&ft=ARfugB8vq8ZmorUe0c_vjKRx45hLrus&mime_type=video_mp4&qs=0&rc=aWk2PGhkZGdoZGg1aTppPEBpajZvOTg6Zms6azMzZjczM0AtXjBgNjFiNTIxM18tLTUyYSM1bmtzcjRncW5gLS1kMWNzcw%3D%3D&l=20230529155744079042443CA4D9D0B139&btag=e00080000&asc=1",
        "fileName.mp4");
    if (downloaded) {
      print("file downloaded");
    } else {
      print("not downloaded error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? LinearProgressIndicator(
                value: progress,
                minHeight: 20,
              )
            : TextButton(
                onPressed: () {
                  downloadFile();
                },
                child: const Text("Storage")),
      ),
    );
  }
}
