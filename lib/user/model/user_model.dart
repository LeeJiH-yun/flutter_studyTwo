import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_studytwo/common/utils/data_utils.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase{
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase{}

@JsonSerializable()
class UserModel extends UserModelBase{
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });
  
  factory UserModel.fromJson(Map<String, dynamic>json)
  => _$UserModelFromJson(json);
}
//json으로부터 클래스 인스턴스로 바꿀 수 있따.