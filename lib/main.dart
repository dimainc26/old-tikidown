

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikidown/pages/downs_page.dart';
import 'package:tikidown/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Lato",
        primarySwatch: Colors.blue,
      ),
      home: const Base(),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: PageView(
            pageSnapping: false,
              physics: NeverScrollableScrollPhysics(),
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
                      pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
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
                      pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
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

