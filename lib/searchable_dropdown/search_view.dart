import 'package:flutter/material.dart';

import 'package:vexana/vexana.dart';

import 'model/item_list.dart';
import 'searchable_dropdown_widget.dart';

class NetworkService {
  late INetworkManager networkManager;
  static NetworkService? _instance;
  static NetworkService get instance {
    if (_instance == null) return _instance = NetworkService._init();
    return _instance!;
  }

  NetworkService._init() {
    final baseOptions = BaseOptions();
    networkManager = NetworkManager(options: baseOptions);
  }
}

class SearchableView extends StatelessWidget {
  const SearchableView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchView Title')),
      body: const SearchAbleDropdownWithPagintedRequestExample(),
    );
  }
}

class SearchAbleDropdownWithPagintedRequestExample extends StatelessWidget {
  const SearchAbleDropdownWithPagintedRequestExample({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchableDropDownWidget(
        hintText: 'Anime Ara',
        getRequest: (page, key) {
          return getCustomerList(page: page, key: key);
        },
        nameField: 'title',
        label: 'Anime seç',
        leadingIcon: const Icon(Icons.palette_outlined),
        style: TextStyle(color: Colors.black.withOpacity(0.8)),
        onItemSelected: (selectedItem) {
          if (selectedItem is Data) debugPrint(selectedItem.title);
        });
  }

  Future<AnimeList?> getCustomerList({required int page, String? key}) async {
    try {
      String url = "https://api.jikan.moe/v4/anime?page=$page";
      if (key != null && key.isNotEmpty) url += "&q=$key";
      var response = await NetworkService.instance.networkManager
          .send<AnimeList, AnimeList>(
        url,
        parseModel: AnimeList(),
        method: RequestType.GET,
      );
      if (response.error != null) throw Exception(response.error);
      return response.data;
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
    }
    return null;
  }
}
