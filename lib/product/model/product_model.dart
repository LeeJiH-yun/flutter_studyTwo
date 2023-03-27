import 'package:flutter_studytwo/common/model/model_with_id.dart';
import 'package:flutter_studytwo/common/utils/data_utils.dart';
import 'package:flutter_studytwo/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId{
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final int price;
  final RestaurantModel restaurant; //항목 선택시 레스토랑 상세 정보로 이동하기 위함

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic>json)
  => _$ProductModelFromJson(json);
}