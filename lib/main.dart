// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikidown/ads/ad_helper.dart';
import 'package:tikidown/ads/app_open_ad_manager.dart';
import 'package:tikidown/ads/lifecycle_reactor.dart';
import 'package:tikidown/api/data_class.dart';
import 'package:tikidown/api/dio_client.dart';
import 'package:tikidown/api/user_class.dart';
import 'package:tikidown/api/user_post_class.dart';
import 'package:tikidown/api/video_class.dart';
import 'package:tikidown/neo.dart';
import 'package:tikidown/pages/downs_page.dart';
import 'package:tikidown/pages/home_page.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

List<String> testDeviceIds = ['2BDAED443CEDF01EDE59C58F5B378812'];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ignore: unused_element
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiki-Down',
      theme: ThemeData(
        fontFamily: "Lato",
        primarySwatch: Colors.blue,
      ),
      home: Neo(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DioClient _client = DioClient();

  var videoData = null;

  searchVideo(link) {
    _client.infoUser(userInfo: UserInfo(id: link));
    setState(() {
      videoData = VideoInfo.fromJson(_client.getUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Column(
        children: [
          Container(
              height: Get.height / 2 + 40,
              width: Get.width,
              color: Colors.greenAccent,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: (Get.height / 2) - 100,
                    child: Stack(
                      children: [
                        Container(
                          width: Get.width - 20,
                          height: (Get.height / 2) - 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
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
                              border: Border.all(color: Colors.grey, width: 2),
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                            bottom: 40,
                            left: 120,
                            child: Text(
                              "@diima_02",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width - 20,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width - 20,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                    ),
                  ),
                ],
              )),
          TextButton(
            onPressed: () {
              searchVideo("https://vm.tiktok.com/ZM2NWhwLX");
            },
            child: Text("Clicker Ici man"),
          ),
          videoData != null ? Text(videoData.name) : const SizedBox(height: 1),
        ],
      ),
    );
  }
}

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final PageController pageController = PageController();

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

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
              _loadInterstitialAd();

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: PageView(
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [
              Home(),
              Downloads(),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.only(top: 6),
            width: Get.width - 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient:
                    const LinearGradient(colors: [Colors.white, Colors.white])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    if (pageController.hasClients) {
                      if (_interstitialAd != null) {
                        _interstitialAd?.show();
                      }
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    }
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "./imgs/home.png",
                        width: 50,
                      ),
                      const Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            color: Color.fromARGB(255, 90, 90, 90)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: Image.asset(
                    "./imgs/logo.png",
                    width: 50,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (pageController.hasClients) {
                      if (_interstitialAd != null) {
                        _interstitialAd?.show();
                      }
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    }
                  },
                  child: Column(children: [
                    Image.asset(
                      "./imgs/down.png",
                      width: 50,
                    ),
                    const Text(
                      "Downs",
                      style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          color: Color.fromARGB(255, 90, 90, 90)),
                    )
                  ]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
