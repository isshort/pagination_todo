import 'package:flutter/material.dart';
import 'package:pagination_todo/searchable_dropdown/model/base_model.dart';

enum SearchableControllerState { initial, busy, error, loaded }

class SearchableController {
  final ValueNotifier<SearchableControllerState> state =
      ValueNotifier<SearchableControllerState>(
          SearchableControllerState.initial);

  ScrollController scrollController = ScrollController();
  GlobalKey key = GlobalKey();
  FocusNode searchFocusNode = FocusNode();
  final ValueNotifier<BaseModel?> selectedItem =
      ValueNotifier<BaseModel?>(null);

  final ValueNotifier<List<BaseModel>?> itemList =
      ValueNotifier<List<BaseModel>?>(null);

  late Function(int page, String? key)? getRequestFun;
  bool _hasMoreData = true;
  int _page = 1;
  String searchText = '';

  void dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
  }

  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        searchText.isNotEmpty
            ? getRequest(page: _page, key: searchText)
            : getRequest(page: _page);
      }
    });
  }

  Future<void> getRequest(
      {required int page, String? key, bool isNewSearch = false}) async {
    if (getRequestFun != null) {
      if (isNewSearch) {
        _page = 1;
        itemList.value = null;
        _hasMoreData = true;
      }
    }

    if (!_hasMoreData) return;
    try {
      state.value = SearchableControllerState.busy;
      final response = await getRequestFun!(page, key);
      if (response != null) {
        itemList.value ??= [];
        itemList.value = itemList.value! + response.data;
        if (response.data != null &&
            response.pagination?.items?.count != null &&
            response.data.length < response.pagination?.items?.count) {
          _hasMoreData = false;
        } else {
          _page = _page + 1;
        }
        state.value = SearchableControllerState.loaded;
      }
      debugPrint('has more data: $_hasMoreData');
    } catch (exception) {
      state.value = SearchableControllerState.error;
      throw Exception(exception);
    }
  }
}
