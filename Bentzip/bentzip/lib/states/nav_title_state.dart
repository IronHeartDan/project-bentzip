import 'package:flutter_bloc/flutter_bloc.dart';

class NavTitleState extends Cubit<String> {
  NavTitleState(super.initialState);

  void setNavTitle(String current) {
    emit(current);
  }
}
