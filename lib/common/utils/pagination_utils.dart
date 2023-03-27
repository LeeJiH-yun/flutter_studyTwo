import 'package:flutter/material.dart';
import 'package:flutter_studytwo/common/provider/pagination_provider.dart';

class PaginationUtils{
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if(controller.offset > controller.position.maxScrollExtent - 400){
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}