import 'package:flutter_studytwo/common/model/model_with_id.dart';
import 'package:flutter_studytwo/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap
}

@JsonSerializable() //클래스를 JsonSerializable로 자동으로 코드 생성해 줄 것을 예고
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey( //변경하고 싶은 값 위에 선언한다.
    fromJson: DataUtils.pathToUrl, //json으로부터 인스턴스를 만들고 싶을 때 실행하고 싶은 함수를 넣는다. 파라미터는 넣어줄 필요없다.
    //toJson: , //json으로 변경될 때 실행하고 싶은 함수를 넣는다. 수정하고 다시 flutter pub run build_runner build해줘야한다.
  )
  final String thumbUrl; //반환된 값이 여기에 다시 저장이 된다.
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) //입력받기
    => _$RestaurantModelFromJson(json); // 구조: _$지금클래스이름FormJson()

    Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}