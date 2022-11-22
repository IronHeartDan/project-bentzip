import 'package:bentzip/models/school_teacher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeachersState extends Cubit<List<SchoolTeacher>?> {
  TeachersState(super.initialState);

  void setTeachers(List<SchoolTeacher>? teachers) {
    emit(teachers);
  }
}
