import 'package:json_annotation/json_annotation.dart';

part 'data_class.g.dart';

@JsonSerializable()
class Data {
  Data({
    required this.id,
    required this.name,
    this.username,
    this.profileImg,
    this.thumbnail,
    this.views,
    this.loves,
    this.comments,
    this.shares,
    this.no_wm,
    this.wm,
    this.sound_name,
    this.sound_url,
  });

  int id;
  String? name;
  String? username;
  String? profileImg;

  String? thumbnail;
  String? views;
  String? loves;
  String? comments;
  String? shares;

  String? no_wm;
  String? wm;

  String? sound_name;
  String? sound_url;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
