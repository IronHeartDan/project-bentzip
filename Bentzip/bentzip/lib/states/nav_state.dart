import 'package:flutter_bloc/flutter_bloc.dart';

class NavState extends Cubit<int> {
  NavState(super.initialState);
  void setNav(int current) {
    emit(current);
  }
}
