import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tikidown/api/dio_client.dart';
import 'package:tikidown/api/user_post_class.dart';
import 'package:tikidown/pages/premium_page.dart';
import 'package:tikidown/ads/ad_helper.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    _loadInterstitialAd();
  }

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    linkController.dispose();

    super.dispose();
  }

  bool downloading = false;
  var progressString = "";

  Future<String> get _localPath async {
    Directory? dir = await getExternalStorageDirectory();

    debugPrint(dir!.path);

    return dir.path;
  }

  Future<void> downloadFile(url) async {
    Dio dio = Dio();

    _localPath;

    if (kDebugMode) {
      print("directory:: $_localPath");
    }

    try {
      await dio.download(
        url,
        "$_localPath/myvideo_1.mp4",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );
    } catch (e) {
      debugPrint("$e");
    }

    debugPrint("Download complete");
  }

  final linkController = TextEditingController();

  final DioClient _client = DioClient();

  getVideoDatas(link) async {
    var videoData = await _client.infoUser(userInfo: UserInfo(id: link));

    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoData!.no_wm!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 360,
        quality: 100,
        timeMs: 16000);

    print("poooooooo  $thumbnail");

    if (videoData == null) {
      print("Nullleeeer");
    } else {
      Get.bottomSheet(
        Container(
            height: Get.height / 2 + 40,
            width: Get.width,
            decoration: const BoxDecoration(
              color: Color(0xff7577CC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: (Get.height / 2) - 100,
                  child: Stack(
                    children: [
                      Container(
                        width: Get.width - 20,
                        height: (Get.height / 2) - 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: FileImage(File(thumbnail!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: Container(
                            width: 180,
                            color: Colors.red.withOpacity(.4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "V: ${videoData.views!}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "L: ${videoData.loves!}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "C: ${videoData.comments!}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(videoData.profileImg!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 40,
                          left: 120,
                          child: Text(
                            "${videoData.name!} / ${videoData.username!}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    launchDownload(videoData.no_wm!, videoData.username!);
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      width: Get.width - 20,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey,
                      ),
                      child: const Text(
                        "Video authentique",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      width: Get.width - 20,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey,
                      ),
                      child: const Text(
                        "Video avec filigrane",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            )),
        barrierColor: const Color(0xff4E4E74).withOpacity(.6),
        isDismissible: true,
        enableDrag: false,
      );
    }
  }

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
        File saveFile = File("${directory.path}/$fileName");
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

  launchDownload(url, username) async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(url, "${username}_fileName.mp4");
    if (downloaded) {
      setState(() {
        loading = false;
      });

      Get.defaultDialog(
          title: "Status",
          middleText: "Download success!",
          backgroundColor: Colors.teal,
          titleStyle: TextStyle(color: Colors.white),
          middleTextStyle: TextStyle(color: Colors.white),
          radius: 30);
    } else {
      print("not downloaded error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90, left: 230),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                    child: Row(children: [
                      Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: IconButton(
                              onPressed: () {
                                if (_interstitialAd != null) {
                                  _interstitialAd?.show();
                                }
                                Get.to(
                                    transition: Transition.rightToLeft,
                                    () => const Ads());
                              },
                              icon: const Icon(
                                Icons.menu,
                                size: 22,
                                color: Colors.grey,
                              ))),
                      const Text(
                        "Go Premium",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16),
                      )
                    ]),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height / 3.5,
                  child: Center(
                    child: Image.asset("./imgs/logo.png"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    "Download any TikTok Video",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  padding: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
                  width: Get.width - 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextFormField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Paste URL Here",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xff9493A5),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 12),
                  padding:
                      loading ? null : const EdgeInsets.symmetric(vertical: 4),
                  width: Get.width - 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.grey),
                    gradient: const LinearGradient(
                      colors: [Color(0xff7577CC), Color(0xff4E4E74)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: loading
                      ? Container(
                          height: 50,
                          clipBehavior: Clip.hardEdge,
                          // margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Positioned.fill(
                                child: LinearProgressIndicator(
                                  //Here you pass the percentage
                                  value: progress,
                                  color: Colors.white24,
                                  
                                  backgroundColor: Color(0xff7577CC).withAlpha(20),
                                ),
                              ),
                              const Center(
                                child: Text('Download...'),
                              )
                            ],
                          ),
                        )
                      : MaterialButton(
                          onPressed: () {
                            getVideoDatas(linkController.value.text);
                          },
                          child: const Icon(
                            Icons.search,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Column(
                  children: [
                    if (_bannerAd != null)
                      SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
