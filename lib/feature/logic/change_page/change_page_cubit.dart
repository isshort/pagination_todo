import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_page_state.dart';

class ChangePageCubit extends Cubit<int> {
  ChangePageCubit() : super(0);
  int currentPage = 0;
  void changePage(int page) {
    currentPage = page;
    emit(currentPage);
  }
}
