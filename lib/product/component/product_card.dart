import 'package:flutter/material.dart';
import 'package:flutter_studytwo/common/const/colors.dart';
import 'package:flutter_studytwo/product/model/product_model.dart';
import 'package:flutter_studytwo/restaurant/model/restaurantDetail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model
  }){
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price
    );
  }

  factory ProductCard.fromRestaurantProductModel({ //리턴 값이 필요하다 ^ㅜ^.. 깜빡했더니 오류나서 알아두기
    required RestaurantProductModel model,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight( //내부에 있는 모든 위젯들이 최대 크기를 차지한 위젯만큼 크기를 차지 하게 된다.
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(
                  8.0
              ),
              child: image
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //intrinsicHeight 위젯을 사용함으로 제대로 먹힌다.
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    detail,
                    overflow: TextOverflow.ellipsis, //내용이 넘어가면 ...을 넣어주기 위해
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: BODY_TEXT_COLOR
                    ),
                  ),
                  Text(
                    '$price',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
