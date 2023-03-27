import 'package:flutter_studytwo/common/utils/data_utils.dart';
import 'package:flutter_studytwo/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurantDetail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products; //리스트 가져올 경우

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic>json)
    => _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl, //공통적으로 사용하기 위함
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic>json)
  => _$RestaurantProductModelFromJson(json);
}
