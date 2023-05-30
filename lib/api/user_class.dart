import 'package:tikidown/api/data_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_class.g.dart';

@JsonSerializable()
class User {
  User({
    required this.data,
  });

  Data data;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
