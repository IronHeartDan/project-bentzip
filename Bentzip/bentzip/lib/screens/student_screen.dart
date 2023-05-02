import 'dart:ui';

import 'package:bentzip/models/school_student.dart';
import 'package:bentzip/screens/add_student.dart';
import 'package:bentzip/screens/student_profile.dart';
import 'package:bentzip/screens/students_table.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/primary_button.dart';
import 'package:bentzip/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/nav_state.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with AutomaticKeepAliveClientMixin {
  final _navController = PageController(initialPage: 1);
  double currentNav = 1;

  SchoolStudent? _schoolStudent;

  Future _handleNav() async {
    if (currentNav == 0 || currentNav == 2) {
      context.read<NavState>().setNav(3);
    } else {
      context.read<NavState>().setNav(0);
    }
  }

  Future _showStudentProfile(SchoolStudent student) async {
    setState(() {
      _schoolStudent = student;
      currentNav = 0;
    });
    context.read<NavState>().setNav(-1);
    _navController.animateToPage(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        _handleNav();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            !Responsive.isSmall(context)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                    text: "Back",
                    onPress: () {
                      _handleNav();
                    }),
                const SizedBox(
                  width: 20,
                ),
                Visibility(
                  visible: currentNav == 1,
                  child: PrimaryButton(
                    text: "Add Student",
                    onPress: () {
                      setState(() {
                        currentNav = 2;
                      });
                      context.read<NavState>().setNav(-1);
                      _navController.animateToPage(2,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease);
                    },
                  ),
                )
              ],
            )
                : const FittedBox(),
            !Responsive.isSmall(context)
                ? const SizedBox(
              height: 20,
            )
                : const FittedBox(),
            Expanded(
                child: Card(
                  margin: const EdgeInsets.all(0),
                  clipBehavior: Clip.hardEdge,
                  elevation: 0,
                  shape: !Responsive.isSmall(context)
                      ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))
                      : const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: BlocListener<NavState, int>(
                    listener: (blocContext, navState) {
                      if (navState == 3) {
                        setState(() {
                          currentNav = 1;
                        });
                        _navController.animateToPage(1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease);
                      }
                    },
                    child: PageView(
                      controller: _navController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _schoolStudent != null
                            ? StudentProfile(
                          student: _schoolStudent!,
                        )
                            : const FittedBox(),
                        StudentsTable(showStudentProfile: _showStudentProfile),
                        AddStudent(handleNav: _handleNav),
                      ],
                    ),
                  ),
                ))
          ],
        ),
        floatingActionButton: Responsive.isSmall(context)
            ? AnimatedScale(
          scale: currentNav == 1 ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: FloatingActionButton(
            backgroundColor: primaryDarkColor,
            onPressed: () {
              setState(() {
                currentNav = 2;
              });
              context.read<NavState>().setNav(-1);
              _navController.animateToPage(2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease);
            },
            child: const Icon(Icons.add),
          ),
        )
            : null,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
