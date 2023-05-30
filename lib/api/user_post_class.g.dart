// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as String,
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

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
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
