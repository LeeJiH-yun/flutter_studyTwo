import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

//클래스로 상태를 구분할 때 베이스 클래스를 만든다.
abstract class CursorPaginationBase {}

//문제 있을 때 상태 (에러)
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

//로딩할 때 상태
class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  //제너릭<T>을 쓰게 되면 genericArgumentFactories:true를 넣어줘야 한다.
  final CursorPaginationMeta meta;
  final List<T> data;

  //T타입에 데이터가 어떻게 될지 모르니까 그 타입들을 json으로부터 어떻게 인스턴스화 할 것인지 정의가 필요하다.
  CursorPagination({
    required this.meta,
    required this.data
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT)
      //T타입이 fromJson으로부터 값을 어떻게 받아 오는지 정의 = T Function(Object? json) fromJsonT
      =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

//새로고침 할 때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

//리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}