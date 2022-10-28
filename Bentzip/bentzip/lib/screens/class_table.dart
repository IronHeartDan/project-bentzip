import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/secondary_buttton.dart';

class ClassTable extends StatefulWidget {
  const ClassTable({Key? key}) : super(key: key);

  @override
  State<ClassTable> createState() => _ClassTableState();
}

class _ClassTableState extends State<ClassTable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (buildContext , boxConstraints ) {
        return  SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: boxConstraints.maxWidth
            ),
            child: DataTable(
              showCheckboxColumn: true,
              showBottomBorder: true,
              columns: const [
                DataColumn(label: Text("Class")),
                DataColumn(label: Text("Section")),
                DataColumn(label: Text("")),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text("1")),
                  DataCell(Row(
                    children: [
                      Chip(
                        label: const Text(
                          "A",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Chip(
                        label: const Text(
                          "B",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Chip(
                        label: const Text(
                          "C",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Chip(
                        label: const Text(
                          "D",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    ],
                  ),),
                  DataCell(SecondaryButton(text: "Add Section", onPress: () {  },)),
                ], onSelectChanged: (selected) {}, selected: true),
                DataRow(cells: [
                  const DataCell(Text("2")),
                  DataCell(Row(
                    children: [
                      Chip(
                        label: const Text(
                          "A",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Chip(
                        label: const Text(
                          "B",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Chip(
                        label: const Text(
                          "C",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    ],
                  )),
                  const DataCell(Text("1")),
                ], onSelectChanged: (selected) {}, selected: false)
              ],
            ),
          ),
        );
      },
    );
  }
}
