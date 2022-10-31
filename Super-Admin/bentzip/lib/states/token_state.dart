import 'package:bentzip/models/token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenState extends Cubit<Token?> {
  TokenState(super.initialState);

  void setUser(Token? user) {
    emit(user);
  }
}
