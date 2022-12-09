import 'dart:convert';

import 'package:http/http.dart';
import 'package:pagination_todo/bloc_inifite_list/data/models/post.dart';

class PostService {
  static const FETCH_LIMIT = 15;
  final _baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<dynamic>> fetchPosts(int page) async {
    try {
      final response =
          await get(Uri.parse("$_baseUrl?_limit=$FETCH_LIMIT&_page=$page"));
      return jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }
}
