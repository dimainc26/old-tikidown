class VideoInfo {
  final String? name;
  final String? username;
  final String? thumbnail;
  final String? profileImg;
  final String? views;
  final String? loves;
  final String? comments;
  final String? shares;
  final String? no_wm;
  final String? wm;

  VideoInfo(
      {required this.name,
      required this.username,
      required this.profileImg,
      required this.thumbnail,
      required this.views,
      required this.loves,
      required this.comments,
      required this.shares,
      required this.no_wm,
      required this.wm,
      });

  VideoInfo.fromJson(Map json)
      : name = json["name"],
        username = json["username"],
        profileImg = json["profileImg"],
        thumbnail = json["thumbnail"],
        views = json["views"],
        loves = json["loves"],
        comments = json["comments"],
        shares = json["shares"],
        no_wm = json["no_wm"],
        wm = json["wm"];
}
