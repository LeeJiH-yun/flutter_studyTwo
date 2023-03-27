import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/model/model_with_id.dart';
import 'package:flutter_studytwo/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId>{ //제너릭을 받는 이유는 외부에서 타입을 정해주기 위함
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}