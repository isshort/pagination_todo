import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pagination_todo/bloc_inifite_list/data/repo/post_repo.dart';

import '../../data/models/post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this.repository) : super(PostInitial());

  int page = 1;
  final PostsRepository repository;

  void loadPosts() {
    if (state is PostsLoading) return;
    final currentState = state;
    var oldPosts = <Post>[];
    if (currentState is PostsLoaded) {
      oldPosts = currentState.posts;
    }
    emit(PostsLoading(oldPosts, isFirstFetch: page == 1));

    repository.fetchPosts(page).then((newPosts) {
      page++;
      final posts = (state as PostsLoading).oldPosts;
      posts.addAll(newPosts);
      emit(PostsLoaded(posts));
    });
  }
}
