import 'dart:convert';

import 'package:bentzip/models/school_student.dart';
import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/screens/student_profile.dart';
import 'package:bentzip/screens/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  late var header;
  bool loading = false;

  late SchoolTeacher _teacher;
  late SchoolStudent _student;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    _getProfile();
    super.initState();
  }

  Future _getProfile() async {
    setState(() {
      loading = true;
    });

    var teacherUri =
        Uri.parse("$serverURL/getTeacher?id=${user.id}&school=${user.school}");
    var studentUri =
        Uri.parse("$serverURL/getStudent?id=${user.id}&school=${user.school}");
    var res = await http.get(user.role == 1 ? teacherUri : studentUri,
        headers: header);
    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      setState(() {
        loading = false;
      });

      if (res.body.isEmpty) {
        showSnack("Error Occurred", true);
        return;
      }
      var resBody = jsonDecode(res.body);

      if (user.role == 1) {
        _teacher = SchoolTeacher.fromJson(resBody);
      } else {
        _student = SchoolStudent.fromJson(resBody);
      }
      setState(() {});
    }
  }

  void navBack() {
    Navigator.of(context).pop();
  }

  void showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error ? Colors.red : Colors.green,
      content: Text(msg),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : user.role == 1
            ? TeacherProfile(teacher: _teacher)
            : StudentProfile(student: _student);
  }
}
