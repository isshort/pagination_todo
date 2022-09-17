import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemPagination extends StatefulWidget {
  const ItemPagination({super.key, required this.itemsList});
  final Future<List<String>> Function(int page) itemsList;
  @override
  State<ItemPagination> createState() => _ItemPaginationState();
}

class _ItemPaginationState extends State<ItemPagination> {
  final _pageSize = 20;
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final newItems = await widget.itemsList(pageKey);
    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, String>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<String>(
        itemBuilder: (context, item, index) => ListTile(
          leading: const FlutterLogo(),
          title: Text(item),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
