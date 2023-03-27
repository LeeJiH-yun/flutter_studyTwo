import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/layout/defalut_layout.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/utils/pagination_utils.dart';
import 'package:flutter_studytwo/product/component/product_card.dart';
import 'package:flutter_studytwo/rating/component/rating_card.dart';
import 'package:flutter_studytwo/rating/model/rating_model.dart';
import 'package:flutter_studytwo/restaurant/component/restaurant_card.dart';
import 'package:flutter_studytwo/restaurant/model/restaurantDetail_model.dart';
import 'package:flutter_studytwo/restaurant/model/restaurant_model.dart';
import 'package:flutter_studytwo/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_studytwo/restaurant/provider/restaurant_rating_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref
        .read(restaurantProvider.notifier)
        .getDetail(id: widget.id); //widget.id는 상품의 id이다.

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: '불타는 떡볶이',
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProduct(products: state.products),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
    );
  }

  //리뷰 ui
  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RatingCard.fromModel(model: models[index]),
                ),
            childCount: models.length),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero // SkeletonParagraph 자체 패딩 삭제
              ),
            ),
          ),
        )),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProduct(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index]; //model값을 가져올 수 있는 방법

          return Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: ProductCard.fromRestaurantProductModel(model: model),
          );
        },
        childCount: products.length,
      )),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
