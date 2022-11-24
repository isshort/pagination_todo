import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/load_data/load_data_cubit.dart';
import 'items_pagination.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<LoadDataCubit, LoadDataState>(
        builder: (context, state) {
          if (state is LoadDataSuccess) {
            return Column(
              children: [
                // const SizedBox(height: 40, child: MenuList()),
                Expanded(child: ItemPagination(
                  itemsList: (page) async {
                    return context.read<LoadDataCubit>().fetchData(page);
                  },
                )),
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
