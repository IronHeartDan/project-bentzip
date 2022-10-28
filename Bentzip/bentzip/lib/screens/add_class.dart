import 'dart:ui';

import 'package:bentzip/screens/add_teacher_form.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:bentzip/widgets/secondary_buttton.dart';
import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/nav_state.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass>
    with AutomaticKeepAliveClientMixin {
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

  Future _handleNav() async {
    if (currentNav == 1) {
      context.read<NavState>().setNav(1);
      _navController.animateToPage(0,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    } else {
      context.read<NavState>().setNav(0);
    }
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
                        visible: currentNav == 0,
                        child: PrimaryButton(
                          text: "Add Class",
                          onPress: () {
                            context.read<NavState>().setNav(-1);
                            _navController.animateToPage(1,
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
                  if (navState == 1) {
                    _navController.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }
                },
                child: PageView(
                  controller: _navController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                     NativeDataTable(
                       header: const Text("Classes"),
                       actions: const [
                         Icon(Icons.add)
                       ],
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
                         ], onSelectChanged: (selected) {}, selected: false),
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
                    AddTeacherForm(handleNav: _handleNav),
                  ],
                ),
              ),
            ))
          ],
        ),
        floatingActionButton: Responsive.isSmall(context)
            ? AnimatedScale(
                scale: currentNav == 1 ? 0 : 1,
                duration: const Duration(milliseconds: 100),
                child: FloatingActionButton(
                  backgroundColor: primaryDarkColor,
                  onPressed: () {
                    context.read<NavState>().setNav(-1);
                    _navController.animateToPage(1,
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
