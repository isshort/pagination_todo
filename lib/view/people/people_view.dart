import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_todo/view/people/people_cubit.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PeopleCubit(),
      child: const PeopleScreen(),
    );
  }
}

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<PeopleCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('PeopleScreen Title')),
      body: Column(children: [
        _Header(),
        Expanded(
          child: InfiniteList(
            itemCount: state.values.length,
            onFetchData: () => context.read<PeopleCubit>().loadData(),
            itemBuilder: (context, index) => ListTile(
              dense: true,
              title: Text(state.values[index].name),
            ),
          ),
        )
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 8,
          ),
          child: Text(
            'A maximum of 40 items can be fetched.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
