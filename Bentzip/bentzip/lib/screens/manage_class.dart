import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../states/nav_title_state.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/repository.dart';
import '../utils/responsive.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/secondary_button.dart';

class ManageClass extends StatefulWidget {
  const ManageClass({Key? key}) : super(key: key);

  @override
  State<ManageClass> createState() => _ManageClassState();
}

class _ManageClassState extends State<ManageClass> {
  late User user;
  late Repository repository;
  late dynamic details;
  List<int> selectedStudents = [];
  int originalLength = 0;
  bool edit = false;
  late Future infoFuture = _getAttendanceInfo();

  @override
  void initState() {
    user = context.read<UserState>().state!;
    repository = RepositoryProvider.of<Repository>(context);
    super.initState();
  }

  Future _getAttendanceInfo() async {
    try {
      details = await repository.fetchAttendanceInfo(user.assignedClass!);
      details["students"].forEach((student) {
        if (student["present"] && !selectedStudents.contains(student["_id"])) {
          selectedStudents.add(student["_id"]);
        }
      });
      originalLength = selectedStudents.length;
    } catch (e) {
      print(e);
      return;
    }
    if (!mounted) return details;
    if (context.read<NavState>().state != 3) return details;
    context
        .read<NavTitleState>()
        .setNavTitle("Class  ${details["standard"]} : ${details["section"]}");
    return details;
  }

  Future _markAttendance() async {
    var students = details['students'].map((student) {
      return {
        "user": student['_id'],
        "standard": details["standard"],
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "present": selectedStudents.contains(student['_id']) ? 1 : 0
      };
    }).toList();

    try {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog(detail: "Marking Attendance");
          });
      await repository.setAttendance({
        "class": details["_id"],
        "role": 2,
        "updated": edit,
        "users": students
      });
      navBack();
      showSnack("Attendance Marked", false);
      setState(() {
        infoFuture = _getAttendanceInfo();
        edit = false;
      });
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

  @override
  Widget build(BuildContext context) {
    if (user.assignedClass == null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Responsive.isSmall(context)
                ? null
                : const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Image.asset(
                  "assets/asset_null_class.png",
                )),
            const SizedBox(
              height: 20,
            ),
            Text(
              "No Class Assigned",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 24),
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
      future: infoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;

          if (data['lastAttendanceDate'] != null &&
              DateFormat("yyyy-MM-dd")
                      .format(DateTime.parse(data['lastAttendanceDate'])) ==
                  DateFormat("yyyy-MM-dd").format(DateTime.now()) &&
              !edit) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Responsive.isSmall(context)
                      ? null
                      : const BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Image.asset(
                        "assets/asset_marked.png",
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Attendance Marked\nFor Today",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SecondaryButton(
                      text: "Edit",
                      onPress: () {
                        setState(() {
                          edit = true;
                        });
                      })
                ],
              ),
            );
          }

          return Scaffold(
            body: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Responsive.isSmall(context)
                      ? null
                      : const BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: !Responsive.isSmall(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)
                        : const EdgeInsets.all(10),
                    color: primaryColor,
                    child: Text(
                      "Students",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data["students"].length,
                        itemBuilder: (context, index) {
                          var student = data["students"][index];
                          var studentId = student["_id"];
                          return ListTile(
                            mouseCursor: SystemMouseCursors.copy,
                            hoverColor: Colors.pink,
                            title: Text(student["name"]),
                            subtitle: Text("$studentId"),
                            trailing: Checkbox(
                              value: selectedStudents.contains(studentId),
                              onChanged: (bool? selected) {
                                if (selected != null && selected) {
                                  selectedStudents.add(studentId);
                                } else {
                                  selectedStudents.remove(studentId);
                                }
                                setState(() {});
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            floatingActionButton: AnimatedScale(
              scale: originalLength != selectedStudents.length ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: FloatingActionButton.extended(
                isExtended: true,
                onPressed: () {
                  _markAttendance();
                },
                backgroundColor: primaryColor,
                label: const Text("Mark Attendance"),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );
  }
}
