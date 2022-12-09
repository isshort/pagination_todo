import 'package:pagination_todo/bloc_inifite_list/data/service/post_service.dart';

import '../models/post.dart';

class PostsRepository {
  final PostService service;

  PostsRepository(this.service);

  Future<List<Post>> fetchPosts(int page) async {
    final posts = await service.fetchPosts(page);
    return posts.map((e) => Post.fromJson(e)).toList();
  }
}
