import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/model/cursor_pagination_model.dart';
import 'package:flutter_studytwo/common/model/model_with_id.dart';
import 'package:flutter_studytwo/common/provider/pagination_provider.dart';
import 'package:flutter_studytwo/common/utils/pagination_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier), //provider를 외부에서 주입시킨다.
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시 시도'),
          )
        ],
      );
    }

    final cp = state as CursorPagination<T>;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index){
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0
                ),
                child: Center(
                  child: cp is CursorPaginationFetchingMore ? CircularProgressIndicator() : Text('마지막 데이터다.'),
                ),
              );
            }

            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              index,
              pItem
            );
          },
          separatorBuilder: (_, index){ //리스트 사이에 뭘 넣을 건지
            return SizedBox(height: 16.0);
          },
        )
    );
  }
}
