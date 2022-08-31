import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/load_data/load_data_cubit.dart';
import 'items_pagination.dart';
import 'menu_list.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MenuList(),
          BlocBuilder<LoadDataCubit, LoadDataState>(
            builder: (context, state) {
              if (state is LoadDataSuccess) {
                return Expanded(
                    child: ItemPagination(
                  itemsList: (page) async => state.itemList,
                ));
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
