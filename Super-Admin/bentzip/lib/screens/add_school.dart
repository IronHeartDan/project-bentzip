import 'package:bentzip/widgets/add_school_form.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:bentzip/widgets/schools_table.dart';
import 'package:bentzip/widgets/secondary_buttton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/nav_state.dart';

class AddSchool extends StatefulWidget {
  const AddSchool({Key? key}) : super(key: key);

  @override
  State<AddSchool> createState() => _AddSchoolState();
}

class _AddSchoolState extends State<AddSchool> {
  final _navController = PageController();
  double currentNav = 0;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SecondaryButton(
                text: "Back",
                onPress: () {
                  if (currentNav == 1) {
                    _navController.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  } else {
                    context.read<NavState>().setNav(0);
                  }
                }),
            const SizedBox(
              width: 20,
            ),
            Visibility(
              visible: currentNav == 0,
              child: PrimaryButton(
                text: "Add School",
                onPress: () {
                  _navController.animateToPage(1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: PageView(
            controller: _navController,
            children: const [
              SchoolsTable(),
              AddSchoolForm(),
            ],
          ),
        ))
      ],
    );
  }

  List<DataColumn> getColumns() {
    var columns = [
      "School name",
      "Code",
      "Contact no.",
      "Email",
      "Date Of Incorporation",
      "Active"
    ];
    return columns.map((e) => DataColumn(label: Text(e))).toList();
  }

  List<DataRow> getRows() {
    return const [
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
      DataRow(cells: [
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
        DataCell(Text("0")),
      ]),
    ];
  }
}
