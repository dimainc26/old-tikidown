// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tikidown/api/user_post_class.dart';
import 'package:html/parser.dart';

class DioClient {
  final Dio _dio = Dio();

  final _baseUrl = 'https://ttsave.app';

  dynamic userData;

  // Post
  Future<UserInfo?> infoUser({required UserInfo userInfo}) async {
    UserInfo? retrievedUser;

    try {
      Response response = await _dio.post(
        queryParameters: {"mode": "video"},
        '$_baseUrl/download',
        data: userInfo.toJson(),
      );

      String htmlContent = response.data;

      var document = parse(htmlContent);

      var name =
          document.getElementsByTagName("div")[0].children[1].children[0].text;
      var profileImg =
          document.getElementsByTagName("a").first.attributes["href"];
      var username = document.getElementsByTagName("a")[1].text;

      var thumbnail =
          document.getElementsByTagName("div")[0].children[1].children[0].text;
      var views = document
          .getElementsByClassName("gap-2")[0]
          .children[0]
          .children[1]
          .text;
      var loves = document
          .getElementsByClassName("gap-2")[0]
          .children[1]
          .children[1]
          .text;
      var comments = document
          .getElementsByClassName("gap-2")[0]
          .children[2]
          .children[1]
          .text;
      var shares = document
          .getElementsByClassName("gap-2")[0]
          .children[3]
          .children[1]
          .text;

      var no_wm = document
          .getElementById("button-download-ready")
          ?.children[0]
          .attributes["href"];
      var wm = document
          .getElementById("button-download-ready")
          ?.children[1]
          .attributes["href"];

      var sound_name =
          document.getElementsByClassName("gap-1")[0].children[1].text;
      var sound_url =
          document.getElementsByTagName("div")[0].children[1].children[0].text;

      retrievedUser = UserInfo(
          id: "",
          name: name,
          username: username,
          profileImg: profileImg,
          views: views,
          loves: loves,
          comments: comments,
          shares: shares,
          no_wm: no_wm,
          wm: wm,
          thumbnail: thumbnail,
          sound_name: sound_name,
          sound_url: sound_url);

      
    } catch (e) {
      debugPrint('Error creating user: $e');
    }

    debugPrint(userData);

    return retrievedUser;
  }

}
