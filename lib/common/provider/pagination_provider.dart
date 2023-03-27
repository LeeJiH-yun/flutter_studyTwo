import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/model/model_with_id.dart';
import 'package:flutter_studytwo/common/model/pagination_params.dart';
import 'package:flutter_studytwo/common/repository/base_pagination_repository.dart';

//일반화된 pagination

// class PaginationProvider extends StateNotifier<CursorPaginationBase>{
//   final IBasePaginationRepository repository; //외부에서 IBasePaginationRepository 클래스와 관련있는 값을 받아오겠다.
class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>> extends StateNotifier<CursorPaginationBase>{
   final U repository;
// dart에서는 제너릭에서 implements를 사용할 수 없다.

  PaginationProvider({
    required this.repository
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20, //pagination_params의 count와 같은 값
    bool fetchMore = false, //추가로 데이터를 더 가져오기 = true , 새로고침(현재 상태를 덮어씌움) = false
    bool forceRefetch = false, //강제로 다시 로딩하기 = true(CursorPaginationLoading())
  }) async {
    try{
      //5가지 가능성 state의 상태
      //1. CursorPagination - 정상적으로 데이터가 있는 상태
      //2. CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      //3. CursorPaginationError - 에러가 있는 상태
      //4. CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      //5. CursorPaginationFetchMㅁore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      //바로 반환하는 상황
      //1. hasMore가 fasle일 때 (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      //-> 데이터를 가져온 적이 있어야 알 수 있음
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        //state는 CursorPaginationBase를 extends하는 어떤 클래스가 될 수 있어서 지정해주는 것이다.

        if (!pState.meta.hasMore) {
          return; //paginate함수를 더이상 실행하지 않겠다
        }
      }

      //2. 로딩 중일 때 - fetchMore가 true일 때 | fetchMork가 아닐 때-새로고침의 의도가 있다.
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      //PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchingMore : 데이터를 추가로 가져오는 상황
      if (fetchMore) {
        final pSate = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pSate.meta,
          data: pSate.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pSate.data.last.id,
        );
      }
      //데이터를 처음부터 가져오는 상황
      else {
        //만일 데이터가 있는 상황이면 기존데이터를 보존하고 fetch(api요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else { //나머지 상황
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        //기존 데이터에 새로운 데이터 추가하기
        state = resp.copyWith(
          data: [
            ...pState.data, //기존에 있던 데이터에
            ...resp.data //새로운 데이터를 추가한다.
          ],
        );
      }else{
        state = resp;
      }
    }catch(e, stack){
      state = CursorPaginationError(message: '데이터를 가져오지 못했슈');
    }
  }
}