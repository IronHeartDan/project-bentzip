import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionsState extends Cubit<List<Widget>?> {
  ActionsState(super.initialState);

  void setActions(List<Widget>? actions) {
    emit(actions);
  }
}
