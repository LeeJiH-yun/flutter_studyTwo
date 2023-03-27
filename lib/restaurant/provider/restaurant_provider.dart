import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/provider/pagination_provider.dart';
import 'package:flutter_studytwo/restaurant/model/restaurant_model.dart';
import 'package:flutter_studytwo/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
  Provider.family<RestaurantModel?, String>((ref, id){//<반환하는 값, 입력타입>
  final state = ref.watch(restaurantProvider);

  if(state is! CursorPagination){
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
  //firstWhere => 데이터가 존재 하지 않으면 에러
    //firstWhereOrNull => 데이터가 존재 하지 않으면 널을 반환
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    //만일 아직 데이터가 하나도 없는 상태라면(CursorPagination이 아니라면) 데이터를 가져오는 시도를 한다.
    if(state is! CursorPagination){
      await paginate();
    }

    //페이지네이션을 했는데도 state가 CursorPagination이 아닐 때 그냥 리턴
    if(state is! CursorPagination){
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    if(pState.data.where((e) => e.id == id).isEmpty){
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp, //데이터 추가
        ]
      ); //만일 데이터가 없을 때 캐시의 끝에다가 데이터를 추가해준다.
    }else {
      state = pState.copyWith(
          data: pState.data.map<RestaurantModel>(
                  (e) => e.id == id ? resp : e
          ).toList()
        //데이터의 id가 함수에서 입력한 id랑 같다면 새로 요청한 데이터로 대체, 아닐 경우 원래 데이터를 반환
      );
    }
  }
}
