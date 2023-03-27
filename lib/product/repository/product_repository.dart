import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_studytwo/common/const/data.dart';
import 'package:flutter_studytwo/common/dio/dio.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/model/pagination_params.dart';
import 'package:flutter_studytwo/product/model/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_studytwo/common/repository/base_pagination_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>(
    (ref) {
      final dio = ref.watch(dioProvider);

      return ProductRepository(dio, baseUrl: 'http://$ip/product');
    }
);

//http://$ip/product
@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel>{
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}