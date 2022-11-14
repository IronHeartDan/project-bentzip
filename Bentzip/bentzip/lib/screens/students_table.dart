import 'dart:convert';

import 'package:bentzip/models/school_student.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/user_state.dart';

class StudentsTable extends StatefulWidget {
  final Function showStudentProfile;

  const StudentsTable({Key? key, required this.showStudentProfile})
      : super(key: key);

  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  late User user;
  late var header;
  bool loading = false;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    super.initState();
  }

  Future _getStudent(String id) async {
    setState(() {
      loading = true;
    });

    var res = await http.get(
        Uri.parse("$serverURL/getStudent?id=$id&school=${user.school}"),
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
        showSnack("Student with id $id not found", true);
        return;
      }
      var resBody = jsonDecode(res.body);
      widget.showStudentProfile(SchoolStudent.fromJson(resBody));
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  // labelText: "Search with 12 Digit ID",
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
                          _getStudent(id);
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
              : Image.asset("assets/asset_lookup.png"),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
