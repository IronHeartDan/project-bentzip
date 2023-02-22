import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/states/actions_state.dart';
import 'package:bentzip/utils/repository.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/loading_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../models/user.dart';
import '../states/nav_title_state.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class ClassDetails extends StatefulWidget {
  final String id;

  const ClassDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  bool loading = false;
  bool secondaryLoading = false;
  late User user;
  late var headers;
  late var details;
  late Repository repository;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    headers = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    repository = RepositoryProvider.of<Repository>(context);
    _getClass();
    super.initState();
  }

  Future _getClass() async {
    setState(() {
      loading = true;
    });

    try {
      details = await repository.getClassDetails(widget.id);
    } catch (e) {
      print(e);
      return;
    } finally {
      setState(() {
        loading = false;
      });
    }

    if (!mounted) return;
    context
        .read<NavTitleState>()
        .setNavTitle("Class  ${details["standard"]} : ${details["section"]}");
    context.read<ActionsState>().setActions([
      IconButton(
          onPressed: () {}, icon: const Icon(Icons.transfer_within_a_station)),
      IconButton(
          onPressed: () {
            _promote();
          },
          icon: const Icon(Icons.move_up_sharp)),
    ]);
  }

  Future _promote() async {
    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              title: Text(
                "Class  ${details["standard"]} : ${details["section"]}",
              ),
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
                        "Promoting...",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ],
                  )),
            );
          });

      var res = await repository.promoteClass(widget.id);
      navBack();
    } on DioError catch (e) {
      showSnack("${e.response?.data}", true);
      navBack();
    }
  }

  Future _assignTeacher() async {
    setState(() {
      secondaryLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    List<SchoolTeacher> teachers;
    List<int> selected = [];
    List<int> toRemove = [];
    try {
      teachers = await repository.getTeachers();
      for (var element in teachers) {
        if (element.schoolClass == widget.id) {
          element.selected = true;
        }
      }
    } catch (e) {
      print(e);
      return;
    } finally {
      setState(() {
        secondaryLoading = false;
      });
    }
    if (!mounted) return;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: const Text("Assign Teacher"),
              content: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormLabel(
                        text:
                            "Class ${details["standard"]} : ${details["section"]}"),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: teachers.length,
                          itemBuilder: (context, index) {
                            var teacher = teachers[index];
                            return CheckboxListTile(
                              title: Text(teacher.name),
                              subtitle: Text(teacher.id.toString()),
                              value: teacher.selected,
                              onChanged: (bool? value) {
                                if (value == null) return;
                                if (teacher.schoolClass == widget.id) {
                                  if (!value) {
                                    toRemove.add(teacher.id);
                                  } else {
                                    toRemove.add(teacher.id);
                                  }
                                }
                                state(() {
                                  teacher.selected = value;
                                  if (teacher.selected) {
                                    selected.add(teacher.id);
                                  } else {
                                    selected.remove(teacher.id);
                                  }
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navBack();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: () async {
                      if (selected.isEmpty && toRemove.isEmpty) {
                        navBack();
                        return;
                      }
                      navBack();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const LoadingDialog(
                                detail: "Assigning Teachers");
                          });
                      var assigned = await Dio().put("$serverURL/assignClass",
                          data: {"class": details["_id"], "teachers": selected},
                          options: Options(headers: headers));

                      var removed = await Dio().put("$serverURL/assignClass",
                          data: {"class": null, "teachers": toRemove},
                          options: Options(headers: headers));
                      navBack();
                      if (assigned.statusCode == 200 &&
                          removed.statusCode == 200) {
                        showSnack("Teachers Assigned", false);
                        _getClass();
                      }
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ))
              ],
            );
          });
        });
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
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : CustomScrollView(
              slivers: [
                MultiSliver(pushPinnedChildren: true, children: [
                  SliverPinnedHeader(
                      child: Container(
                    padding: !Responsive.isSmall(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)
                        : const EdgeInsets.all(10),
                    color: primaryColor,
                    child: Text(
                      (details["teachers"] as List).isNotEmpty
                          ? "Teachers"
                          : "No Teacher Assigned",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
                  (details["teachers"] as List).isNotEmpty
                      ? const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
                          ),
                        )
                      : const FittedBox(),
                  (details["teachers"] as List).isNotEmpty
                      ? SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            var student = details["teachers"][index];
                            return ListTile(
                              trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.copy),
                              ),
                              title: Text(student["name"]),
                              subtitle: Text("${student["_id"]}"),
                            );
                          }, childCount: (details["teachers"] as List).length),
                        )
                      : const FittedBox(),
                  (details["teachers"] as List).isNotEmpty
                      ? const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 20,
                          ),
                        )
                      : const FittedBox(),
                ]),
                MultiSliver(pushPinnedChildren: true, children: [
                  SliverPinnedHeader(
                      child: Container(
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
                  )),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var student = details["students"][index];
                      return ListTile(
                        mouseCursor: SystemMouseCursors.copy,
                        hoverColor: Colors.pink,
                        title: Text(student["name"]),
                        subtitle: Text("${student["_id"]}"),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.copy),
                        ),
                      );
                    }, childCount: (details["students"] as List).length),
                  )
                ])
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: !secondaryLoading,
        onPressed: secondaryLoading
            ? null
            : () {
                _assignTeacher();
              },
        backgroundColor: primaryColor,
        icon: secondaryLoading
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : null,
        label: const Text("Assign Teacher"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
