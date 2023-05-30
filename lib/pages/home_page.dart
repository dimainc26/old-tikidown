import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tikidown/api/dio_client.dart';
import 'package:tikidown/api/user_post_class.dart';
import 'package:tikidown/api/video_class.dart';
import 'package:tikidown/pages/premium_page.dart';
import 'package:tikidown/ads/ad_helper.dart';

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

  final DioClient _client = DioClient();

  var videoData = null;

  searchVideo(link) {
    _client.infoUser(userInfo: UserInfo(id: link));
    setState(() {
      videoData = VideoInfo.fromJson(_client.getUser());
    });
  }

  bool downloading = false;
  var progressString = "";

  Future<String> get _localPath async {
    Directory? dir = await getExternalStorageDirectory();

    print(dir!.path);

    return dir.path;
  }

  Future<void> downloadFile(url) async {
    Dio dio = Dio();

    _localPath;

    print("directory:: ${_localPath}");

    try {
      await dio.download(
        url,
        "$_localPath/myvideo_1.mp4",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );
    } catch (e) {
      print(e);
    }

    print("Download complete");
  }

  final linkController = TextEditingController();

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
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                    child: MaterialButton(
                      onPressed: () {
                        if (linkController.value.text.isNotEmpty) {
                          searchVideo(linkController.value.text);

                          Get.bottomSheet(
                            Container(
                                height: Get.height / 2 + 40,
                                width: Get.width,
                                color: Colors.greenAccent,
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.grey,
                                              image: const DecorationImage(
                                                image: NetworkImage(
                                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            bottom: 20,
                                            child: Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      videoData.profileImg),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 40,
                                              left: 120,
                                              child: Text(
                                                videoData.name +
                                                    " / " +
                                                    videoData.username,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        downloadFile(videoData.no_wm);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 18),
                                          width: Get.width - 20,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey,
                                          ),
                                          child: const Text(
                                            "Video authentique",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 18),
                                          width: Get.width - 20,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey,
                                          ),
                                          child: const Text(
                                            "Video avec filigrane",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                )),
                            barrierColor:
                                const Color(0xff4E4E74).withOpacity(.6),
                            isDismissible: true,
                            enableDrag: false,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.grey,
                      ),
                    )),
                Column(
                  children: [
                    if (videoData != null) Text(videoData.name),
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
