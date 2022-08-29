import 'package:flutter_bloc/flutter_bloc.dart';

class NavState extends Cubit<int> {
  NavState() : super(0);

  void setNav(int current) {
    emit(current);
  }
}
