import 'package:bentzip/models/user.dart';
import 'package:dio/dio.dart';

import '../models/school_teacher.dart';
import 'constants.dart';

class Repository {
  late User user;
  late Map<String, String>? headers;

  Future getTeacher(int id, String school) async {
    var res = await Dio().get("$serverURL/getTeacher",
        queryParameters: {
          "id": id,
          "school": school,
        },
        options: Options(headers: headers));
    return res.data;
  }

  Future getStudent(int id, String school) async {
    var res = await Dio().get("$serverURL/getStudent",
        queryParameters: {
          "id": id,
          "school": school,
        },
        options: Options(headers: headers));
    return res.data;
  }

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

  Future fetchAttendanceInfo(String id) async {
    var res = await Dio().get("$serverURL/getAttendanceInfo",
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

  Future fetchAttendance() async {
    var res = await Dio().get("$serverURL/getAttendance",
        queryParameters: {"user": user.id, "role": user.role},
        options: Options(headers: headers));
    return res.data;
  }

  Future setAttendance(data) async {
    var res = await Dio().post("$serverURL/setAttendance",
        data: data, options: Options(headers: headers));
    return res;
  }

  Future addLeave(String body)async{
    var res = await Dio().post("$serverURL/requestLeave",
        data: body, options: Options(headers: headers));
    return res;
  }


  Future fetchLeaves(bool isClass) async {
    var queryParameters =
    isClass ? {"class": user.assignedClass} : {"school": user.school};
    var res = await Dio().get("$serverURL/getLeaveRequests",
        queryParameters: queryParameters, options: Options(headers: headers));
    return res.data;
  }
}
