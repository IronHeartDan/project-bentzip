import 'dart:convert';

import 'package:bentzip/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/leave.dart';
import '../models/user.dart';
import '../states/actions_state.dart';
import '../states/nav_state.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/repository.dart';
import '../utils/responsive.dart';

class Item {
  Leave leave;
  bool expanded;

  Item(this.leave, this.expanded);
}

class ClassLeavesManagement extends StatefulWidget {
  const ClassLeavesManagement({Key? key}) : super(key: key);

  @override
  State<ClassLeavesManagement> createState() => _ClassLeavesManagementState();
}

class _ClassLeavesManagementState extends State<ClassLeavesManagement>
    with AutomaticKeepAliveClientMixin {
  late User user;
  late Repository repository;
  late dynamic details;
  List<int> selectedStudents = [];
  int originalLength = 0;
  bool edit = false;
  late var header;
  late Future leavesFuture = _getLeaves();

  @override
  void initState() {
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    context.read<ActionsState>().setActions([
      IconButton(
          onPressed: () {
            setState(() {
              leavesFuture = _getLeaves();
            });
          },
          icon: const Icon(Icons.refresh))
    ]);
    repository = RepositoryProvider.of<Repository>(context);
    super.initState();
  }

  Future _getLeaves() async {
    try {
      details = await repository.fetchLeaves(true);
      return (details as List)
          .map((e) => Item(Leave.fromJson(e), false))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future _updateLeave(String id, int status) async {
    var body = {"id": id, "status": status};

    var res = await http.post(Uri.parse("$serverURL/updateLeave"),
        headers: header, body: jsonEncode(body));

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      _getLeaves();
      setState(() {
        leavesFuture = _getLeaves();
      });
    }
  }

  List<DataRow> _buildRows(List<Item> leaves) {
    return leaves
        .map((item) => DataRow(cells: [
              DataCell(Text(item.leave.userId.toString())),
              DataCell(Text(item.leave.name)),
              DataCell(Text(item.leave.reason)),
              DataCell(Text(item.leave.start)),
              DataCell(Text(item.leave.end)),
              DataCell(Text(item.leave.role == 1 ? "Teacher" : "Student")),
              item.leave.status == 0
                  ? DataCell(Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _updateLeave(item.leave.id, 1);
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              _updateLeave(item.leave.id, -1);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ))
                  : item.leave.status < 0
                      ? const DataCell(Text(
                          "Denied",
                          style: TextStyle(color: Colors.red),
                        ))
                      : const DataCell(Text(
                          "Granted",
                          style: TextStyle(color: Colors.green),
                        )),
            ]))
        .toList();
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

    return BlocListener<NavState, int>(
        listener: (_, state) {
          if (state == 4) {
            context.read<ActionsState>().setActions([
              IconButton(
                  onPressed: () {
                    setState(() {
                      leavesFuture = _getLeaves();
                    });
                  },
                  icon: const Icon(Icons.refresh))
            ]);
          }
        },
        child: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: !Responsive.isSmall(context)
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
          child: FutureBuilder(
              future: leavesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  var leaves = snapshot.data as List<Item>;

                  if (leaves.isEmpty) {
                    return const EmptyState();
                  }

                  return Responsive.isSmall(context)
                      ? SingleChildScrollView(
                          child: ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                leaves[index].expanded = !isExpanded;
                              });
                            },
                            children: leaves
                                .map((e) => ExpansionPanel(
                                      isExpanded: e.expanded,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return ListTile(
                                          title: Text(e.leave.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          subtitle: Text(
                                            e.leave.status == 0
                                                ? "Pending"
                                                : e.leave.status == 1
                                                    ? "Approved"
                                                    : "Declined",
                                            style: TextStyle(
                                                color: e.leave.status == 0
                                                    ? null
                                                    : e.leave.status == 1
                                                        ? Colors.green
                                                        : Colors.red),
                                          ),
                                          leading: e.leave.role == 1
                                              ? const Icon(Icons.school)
                                              : const Icon(
                                                  Icons.account_circle),
                                        );
                                      },
                                      body: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "UserID",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                  e.leave.userId.toString()),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Reason",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(e.leave.reason),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Visibility(
                                              visible: e.leave.status == 0,
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Actions",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: e.leave.status == 0,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        _updateLeave(
                                                            e.leave.id, 1);
                                                      },
                                                      icon: const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        _updateLeave(
                                                            e.leave.id, -1);
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              ),
                                            )
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
                                      DataColumn(label: Text("ID")),
                                      DataColumn(label: Text("Name")),
                                      DataColumn(label: Text("Reason")),
                                      DataColumn(label: Text("From")),
                                      DataColumn(label: Text("To")),
                                      DataColumn(label: Text("Role")),
                                      DataColumn(label: Text("Action")),
                                    ],
                                    rows: _buildRows(leaves),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
