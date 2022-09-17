import 'package:flutter/material.dart';
import 'package:pagination_todo/bootstrap.dart';
import 'package:pagination_todo/view/items_screen.dart';

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
      home: const ItemsScreen(),
    );
  }
}
