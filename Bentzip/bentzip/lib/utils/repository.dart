import 'package:bentzip/models/user.dart';
import 'package:dio/dio.dart';

import '../models/school_teacher.dart';
import 'constants.dart';

class Repository {
  late User user;
  late Map<String, String>? headers;

  Future<List<SchoolTeacher>> getTeachers() async {
    var res = await Dio().get("$serverURL/getTeachers",
        queryParameters: {
          "school": user.school,
        },
        options: Options(headers: headers));
    return (res.data as List).map((e) => SchoolTeacher.fromJson(e)).toList();
  }

  Future getClassDetails(String id) async {
    var res = await Dio().get("$serverURL/getClass",
        queryParameters: {
          "id": id,
        },
        options: Options(headers: headers));
    return res.data;
  }

  Future promoteClass(String classId) async {
    var res = await Dio().post("$serverURL/promote",
        data: {
          "class": classId,
        },
        options: Options(headers: headers));
    return res;
  }
}
