import 'package:dio/dio.dart' hide Headers; //dio에 있는 헤더는 숨겨준다.
import 'package:flutter_studytwo/common/const/data.dart';
import 'package:flutter_studytwo/common/dio/dio.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/model/pagination_params.dart';
import 'package:flutter_studytwo/common/repository/base_pagination_repository.dart';
import 'package:flutter_studytwo/restaurant/model/restaurantDetail_model.dart';
import 'package:flutter_studytwo/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
});

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{
  //http://$ip/restaurant를 일반화할 것임
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken':'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/:id 상세 정보
  @GET('/{id}')
  @Headers({
    'accessToken':'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({ //api요청이므로 외부에서 오기 때문에 future붙여야함
   @Path() required String id,
  });
}