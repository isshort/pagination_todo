import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_todo/bloc_inifite_list/data/service/post_service.dart';
import 'package:pagination_todo/bloc_inifite_list/view/cubit/post_cubit.dart';

import '../data/repo/post_repo.dart';
import 'post_screen.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final PostsRepository repository;
  @override
  void initState() {
    super.initState();
    repository = PostsRepository(PostService());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(repository),
      child: const PostsScreen(),
    );
  }
}
