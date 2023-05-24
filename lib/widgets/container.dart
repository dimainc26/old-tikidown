import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: width - 40,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.orange,
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
            child: Image.asset("./imgs/logo.png"),
          ),
          Container(
            width: Get.width - 180,
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Video Title",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                Text(
                  "Video author".toUpperCase(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xff7577CC), shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.play_arrow)),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xff7577CC), shape: BoxShape.circle),
                      child:
                          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
