import 'package:flutter/material.dart';
import 'package:pagination_todo/bootstrap.dart';

import 'bloc_inifite_list/view/posts_page.dart';

void main() {
  // runApp(const MyApp());
  bootstrap(
    () => const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostPage(),
      // home: const PeopleView(),
    );
  }
}
