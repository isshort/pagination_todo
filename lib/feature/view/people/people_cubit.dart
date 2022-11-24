import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}

/*

loading Restaurant Info with category 





*/
var page = 0;

class PeopleCubit extends Cubit<PeopleState> {
  PeopleCubit() : super(const PeopleState());

  void clear() {
    emit(const PeopleState());
  }

  Future<void> loadData() async {
    print('This is data');
    emit(PeopleState(
      values: state.values,
      isLoading: true,
    ));

    // await Future<void>.delayed(const Duration(microseconds: 400));
    if (state.values.length >= 200) {
      emit(
        PeopleState(
          values: state.values,
          hasRichMax: true,
        ),
      );
      return;
    }
    // for (int i = page; i < page + 20; i++) {
    //   items.add('Index $i');
    // }
    page++;
    print(page);
    print(state.values.length);
    emit(
      PeopleState(
        values: List.generate(
          state.values.length + 4,
          (index) => Person(
            'person $index',
            19 + (index * 0.2).floor(),
          ),
        ),
      ),
    );
  }
}

class PeopleState extends Equatable {
  final List<Person> values;
  final bool isLoading;
  final Object? error;
  final bool hasRichMax;

  const PeopleState({
    this.values = const <Person>[],
    this.isLoading = false,
    this.error,
    this.hasRichMax = false,
  });
  @override
  List<Object?> get props => [isLoading, error, hasRichMax];
}
