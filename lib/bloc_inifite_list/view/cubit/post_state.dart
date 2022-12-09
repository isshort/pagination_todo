part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> posts;

  const PostsLoaded(this.posts);
}

class PostsLoading extends PostState {
  final List<Post> oldPosts;
  final bool isFirstFetch;

  const PostsLoading(this.oldPosts, {this.isFirstFetch = false});
}
