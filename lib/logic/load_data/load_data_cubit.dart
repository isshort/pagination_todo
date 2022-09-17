import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'load_data_state.dart';

class LoadDataCubit extends Cubit<LoadDataState> {
  LoadDataCubit() : super(LoadDataInitial());

  Future<List<String>> loadData(int page) async {
    List<String> items = [];
    // if (page > 60) return [];
    emit(LoadDataInitial());
    for (int i = page; i < page + 20; i++) {
      items.add('Index $i');
    }
    emit(LoadDataSuccess(items));
    return items;
  }

  Future<List<String>> fetchData(int page) async {
    List<String> items = [];
    // if (page > 60) return [];
    for (int i = page; i < page + 20; i++) {
      items.add('Index $i');
    }
    emit(LoadDataSuccess(items));
    return items;
  }
}
