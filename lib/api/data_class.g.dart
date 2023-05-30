// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int,
      name: json['name'] as String?,
      username: json['username'] as String?,
      profileImg: json['profileImg'] as String?,

      thumbnail: json['createdAt'] as String?,
      views: json['updatedAt'] as String?,
      loves: json['updatedAt'] as String?,
      comments: json['updatedAt'] as String?,
      shares: json['updatedAt'] as String?,

      no_wm: json['updatedAt'] as String?,
      wm: json['updatedAt'] as String?,

      sound_name: json['updatedAt'] as String?,
      sound_url: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'profileImg': instance.profileImg,

      'thumbnail': instance.thumbnail,
      'views': instance.views,
      'loves': instance.loves,
      'comments': instance.comments,
      'shares': instance.shares,

      'no_wm': instance.no_wm,
      'wm': instance.wm,

      'sound_name': instance.sound_name,
      'sound_url': instance.sound_url,
    };
