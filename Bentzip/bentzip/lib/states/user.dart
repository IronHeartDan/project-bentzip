import 'package:bentzip/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserState extends Cubit<User?> {
  UserState(super.initialState);

  void setUser(User? user) {
    emit(user);
  }
}
