import 'dart:convert';

import 'package:bentzip/models/leave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({Key? key}) : super(key: key);

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class Item {
  Leave leave;
  bool expanded;

  Item(this.leave, this.expanded);
}

class _LeavesScreenState extends State<LeavesScreen> {
  bool loading = false;
  late User user;
  late var header;
  late List<Item> leaves;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    _getLeaves();
    super.initState();
  }

  Future _getLeaves() async {
    setState(() {
      loading = true;
    });

    var res = await http.get(
        Uri.parse("$serverURL/getLeaveRequests?school=${user.school}&role=2"),
        headers: header);

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      leaves =
          (resBody as List).map((e) => Item(Leave.fromJson(e), false)).toList();
      setState(() {
        loading = false;
      });
    }

    setState(() {
      loading = false;
    });
  }

  List<DataRow> _buildRows() {
    return leaves
        .map((item) => DataRow(cells: [
              DataCell(Text(item.leave.userId.toString())),
              DataCell(Text(item.leave.name)),
              DataCell(Text(item.leave.reason)),
              DataCell(Text(item.leave.start)),
              DataCell(Text(item.leave.end)),
              DataCell(Text(item.leave.role == 1 ? "Teacher" : "Student")),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                ],
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
    return loading
        ? Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : LayoutBuilder(
            builder: (buildContext, boxConstraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: boxConstraints.minWidth),
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
                      rows: _buildRows(),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
