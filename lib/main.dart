
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikidown/ads/ad_helper.dart';
import 'package:tikidown/ads/app_open_ad_manager.dart';
import 'package:tikidown/ads/lifecycle_reactor.dart';
import 'package:tikidown/pages/downs_page.dart';
import 'package:tikidown/pages/home_page.dart';
import 'package:tikidown/neo.dart';

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
      home:  Base(),
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
