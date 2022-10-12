import 'package:flutter_bloc/flutter_bloc.dart';

class AppConnectionState extends Cubit<bool> {
  AppConnectionState() : super(true);

  void setConnection(bool current) {
    emit(current);
  }
}
