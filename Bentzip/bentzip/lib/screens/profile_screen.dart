import 'dart:convert';

import 'package:bentzip/models/school_student.dart';
import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/screens/student_profile.dart';
import 'package:bentzip/screens/teacher_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/repository.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  late Repository repository;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    repository = RepositoryProvider.of<Repository>(context);
    super.initState();
  }

  Future _getProfile() async {
    try {
      if (user.role == 1) {
        var res = await repository.getTeacher(user.id!, user.school);
        return SchoolTeacher.fromJson(res);
      } else {
        var res = await repository.getStudent(user.id!, user.school);
        return SchoolStudent.fromJson(res);
      }
    } on DioError catch (e) {
      showSnack(e.message, true);
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

  Future _requestLeave() async {
    var formKey = GlobalKey<FormState>();
    var startController = TextEditingController();
    var endController = TextEditingController();
    late String startDate;
    late String endDate;
    late String description;
    var today = DateTime.now();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Request Leave"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel(text: "Start Date"),
                  const SizedBox(
                    height: 10,
                  ),
                  FormInput(
                    textEditingController: startController,
                    onSaved: (val) {
                      startDate = val!;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Enter Start Date"
                          : null;
                    },
                    suffixIcon: IconButton(
                        onPressed: () async {
                          var start = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: today,
                              lastDate: today.add(const Duration(days: 60)));
                          if (start != null) {
                            startController.text =
                                DateFormat("yyyy-MM-dd").format(start);
                          }
                        },
                        icon: const Icon(Icons.date_range)),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormLabel(text: "End Date"),
                  const SizedBox(
                    height: 10,
                  ),
                  FormInput(
                    textEditingController: endController,
                    onSaved: (val) {
                      endDate = val!;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Enter End Date"
                          : null;
                    },
                    suffixIcon: IconButton(
                        onPressed: () async {
                          var start = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: today,
                              lastDate: today.add(const Duration(days: 90)));
                          if (start != null) {
                            endController.text =
                                DateFormat("yyyy-MM-dd").format(start);
                          }
                        },
                        icon: const Icon(Icons.date_range)),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormLabel(text: "Description"),
                  const SizedBox(
                    height: 10,
                  ),
                  FormInput(
                    onSaved: (val) {
                      description = val!;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Enter Description"
                          : null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                ),
              ),
              PrimaryButton(
                  text: "Add",
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      navBack();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (buildContext) {
                            return AlertDialog(
                              backgroundColor: primaryColor,
                              content: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Adding Leave Request",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            );
                          });
                      addLeave(startDate, endDate, description);
                    }
                  }),
            ],
          );
        });
  }

  Future addLeave(String start, String end, String description) async {
    var body = jsonEncode({
      "user": user.id!,
      "start": start,
      "end": end,
      "status": 0,
      "reason": description,
      "school": user.school,
    });
    try {
      await repository.addLeave(body);
      showSnack("Leave Requested", false);
    } on DioError catch (e) {
      showSnack(e.message, true);
    } finally {
      navBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return user.role == 1
                  ? TeacherProfile(teacher: data as SchoolTeacher)
                  : StudentProfile(student: data as SchoolStudent);
            }

            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: "Request Leave",
        backgroundColor: primaryDarkColor,
        onPressed: () {
          _requestLeave();
        },
        child: const Icon(Icons.quick_contacts_mail),
      ),
    );
  }
}
