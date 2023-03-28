import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/product/model/product_model.dart';
import 'package:flutter_studytwo/user/model/basket_item_model.dart';
import 'package:collection/collection.dart';

final basketProvider = StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  return BasketProvider();
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  BasketProvider() : super([]);

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      // 만약 장바구니에 상품이 있다면 장바구니에 있는 값에 +1
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count + 1,
                )
              : e)
          .toList();
    } else {
      // 만약 장바구니에 상품이 없다면 장바구니에 상품을 추가한다.
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        )
      ];
    }
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false, //true면 카운트와 상관없이 아예 삭제한다.
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    //장바구니에 상품이 존재하지 않을 때 함수를 반환하고 아무 것도 하지 않는다.
    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    //장바구니에 상품이 존재할 때 상품의 카운트가 1보다 크면 -1 / 상품의 카운트가 1이면 삭제
    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count - 1,
                )
              : e)
          .toList();
    }
  }
}
