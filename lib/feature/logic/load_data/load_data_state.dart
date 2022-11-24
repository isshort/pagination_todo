part of 'load_data_cubit.dart';

@immutable
abstract class LoadDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataInitial extends LoadDataState {}

class LoadDataSuccess extends LoadDataState {
  final List<String> itemList;

  LoadDataSuccess(this.itemList);
  @override
  List<Object?> get props => [itemList];
}
