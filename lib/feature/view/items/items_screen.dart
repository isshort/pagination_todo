import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/change_page/change_page_cubit.dart';
import '../../logic/load_data/load_data_cubit.dart';
import 'item_page.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => LoadDataCubit()..loadData(0),
        ),
        BlocProvider(
          create: (context) => ChangePageCubit(),
        ),
      ],
      child: const ItemPage(),
    );
  }
}
