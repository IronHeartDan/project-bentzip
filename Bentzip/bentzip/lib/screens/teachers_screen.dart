import 'dart:ui';

import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/screens/add_teacher.dart';
import 'package:bentzip/screens/teacher_profile.dart';
import 'package:bentzip/screens/teachers_table.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:bentzip/widgets/secondary_buttton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/nav_state.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key? key}) : super(key: key);

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen>
    with AutomaticKeepAliveClientMixin {
  final _navController = PageController();
  double currentNav = 0;

  SchoolTeacher? _schoolTeacher;

  @override
  void initState() {
    _navController.addListener(() {
      setState(() {
        if (_navController.page != null) {
          currentNav = _navController.page!;
        }
      });
    });
    super.initState();
  }

  Future _handleNav() async {
    if (currentNav == 0 || currentNav == 2) {
      context.read<NavState>().setNav(2);
    } else {
      context.read<NavState>().setNav(0);
    }
  }

  Future _showTeacherProfile(SchoolTeacher teacher) async {
    setState(() {
      _schoolTeacher = teacher;
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
                          text: "Add Teacher",
                          onPress: () {
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
                  if (navState == 2) {
                    _navController.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }
                },
                child: PageView(
                  controller: _navController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _schoolTeacher != null
                        ? TeacherProfile(
                      teacher: _schoolTeacher!,
                    )
                        : const FittedBox(),
                    TeachersTable(showTeacherProfile: _showTeacherProfile),
                    AddTeacher(handleNav: _handleNav),
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
