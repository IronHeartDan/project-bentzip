import 'dart:convert';

import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/utils/repository.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/server_down.dart';

class TeachersTable extends StatefulWidget {
  final Function showTeacherProfile;

  const TeachersTable({Key? key, required this.showTeacherProfile})
      : super(key: key);

  @override
  State<TeachersTable> createState() => _TeachersTableState();
}

class Item {
  SchoolTeacher schoolTeacher;
  bool expanded;

  Item(this.schoolTeacher, this.expanded);
}

class _TeachersTableState extends State<TeachersTable>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late User user;
  late Map<String, String>? header;
  bool loading = false;
  bool error = false;
  late List<Item> teachers;
  late Repository repository;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    repository = RepositoryProvider.of<Repository>(context);
    getTeachers();
    super.initState();
  }

  Future getTeachers() async {
    setState(() {
      loading = true;
    });
    try {
      var res = await repository.getTeachers();
      teachers = res.map((e) => Item(e, false)).toList();
      setState(() {
        loading = false;
        error = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  List<DataRow> _buildRows() {
    return teachers
        .map((item) => DataRow(cells: [
              DataCell(Text(item.schoolTeacher.id.toString())),
              DataCell(Text(item.schoolTeacher.name)),
              DataCell(
                Row(children: [
                  Expanded(child: Text(item.schoolTeacher.email)),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {
                        widget.showTeacherProfile(item.schoolTeacher);
                      },
                      icon: const Icon(Icons.visibility)),
                ]),
              ),
            ]))
        .toList();
  }

  Future _getTeacher(String id) async {
    setState(() {
      loading = true;
    });

    var res = await http.get(
        Uri.parse("$serverURL/getTeacher?id=$id&school=${user.school}"),
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
        showSnack("Teacher with id $id not found", true);
        return;
      }
      var resBody = jsonDecode(res.body);
      widget.showTeacherProfile(SchoolTeacher.fromJson(resBody));
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
    super.build(context);
    if (error) {
      return const ServerDown();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: HexColor("#C7C7C7"),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none
                    // labelText: "Search",
                    ),
              )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  height: 50,
                  child: PrimaryButton(
                      text: "Search",
                      onPress: () {
                        var id = _searchController.text;
                        if (id.isNotEmpty) {
                          _getTeacher(id);
                        }
                      })),
            ],
          ),
        ),
        Expanded(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Responsive.isSmall(context)
                  ? SingleChildScrollView(
                      controller: _scrollController,
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            teachers[index].expanded = !isExpanded;
                          });
                        },
                        children: teachers
                            .map((e) => ExpansionPanel(
                                  isExpanded: e.expanded,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Text(e.schoolTeacher.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      trailing: GestureDetector(
                                          onTap: () {
                                            widget.showTeacherProfile(
                                                e.schoolTeacher);
                                          },
                                          child: const MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Icon(Icons.visibility))),
                                    );
                                  },
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          "ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(e.schoolTeacher.id.toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(e.schoolTeacher.email),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (buildContext, boxConstraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: boxConstraints.minWidth),
                            child: SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 10,
                                showBottomBorder: true,
                                columns: const [
                                  DataColumn(label: Text("Teacher-ID")),
                                  DataColumn(label: Text("Name")),
                                  DataColumn(label: Text("Email")),
                                ],
                                rows: _buildRows(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
