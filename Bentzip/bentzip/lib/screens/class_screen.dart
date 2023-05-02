import 'dart:async';
import 'dart:convert';

import 'package:bentzip/models/school_class.dart';
import 'package:bentzip/screens/class_details.dart';
import 'package:bentzip/utils/UpperCaseFormatter.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/empty_state.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/primary_button.dart';
import 'package:bentzip/widgets/secondary_button.dart';
import 'package:bentzip/widgets/server_down.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/actions_state.dart';
import '../states/nav_state.dart';
import '../states/user_state.dart';
import '../widgets/form_input.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class Item {
  SchoolClass schoolClass;
  bool expanded;

  Item(this.schoolClass, this.expanded);
}

class _ClassScreenState extends State<ClassScreen>
    with AutomaticKeepAliveClientMixin {
  final _navController = PageController(initialPage: 1);
  double currentNav = 1;
  final ScrollController _scrollController = ScrollController();
  bool fabVisible = true;

  bool loading = false;
  bool error = false;
  List<Item> classes = [];
  late User user;
  late var header;

  String? _currentClass;

  @override
  void initState() {
    context.read<ActionsState>().setActions([
      IconButton(
          onPressed: () {
            getClasses();
          },
          icon: const Icon(Icons.refresh))
    ]);
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    getClasses();
    _navController.addListener(() {
      setState(() {
        if (_navController.page != null) {
          currentNav = _navController.page!;
        }
      });
    });
    _scrollController.addListener(() {
      if (!Responsive.isSmall(context)) return;
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!fabVisible) {
          setState(() {
            fabVisible = true;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (fabVisible) {
          setState(() {
            fabVisible = false;
          });
        }
      }
    });
    super.initState();
  }

  Future getClasses() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      var res = await Dio().get("$serverURL/getClasses",
          queryParameters: {
            "school": user.school,
          },
          options: Options(headers: header));

      if (res.statusCode == 400) {
        showSnack(res.data, true);
        return;
      }

      if (res.statusCode == 200) {
        var resBody = res.data;
        classes = (resBody as List)
            .map((e) => Item(SchoolClass.fromJson(e), false))
            .toList();
      }
      setState(() {
        loading = false;
        error = false;
      });
    } on DioError catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  List<DataRow> _buildRows() {
    return classes
        .map((item) => DataRow(cells: [
              DataCell(Text(item.schoolClass.standard.toString())),
              DataCell(
                Row(
                  children: [
                    Expanded(
                        child: Wrap(
                      children: _buildChips(item.schoolClass.classes),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    SecondaryButton(
                      text: "Add Section",
                      onPress: () {
                        _addClass(item.schoolClass, 1);
                      },
                    )
                  ],
                ),
              ),
            ]))
        .toList();
  }

  List<Widget> _buildChips(List<dynamic> classes) {
    return classes
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputChip(
              tooltip: "View Class",
              deleteIconColor: Colors.white,
              onDeleted: () {},
              onPressed: () {
                setState(() {
                  _currentClass = e["id"];
                });
                context.read<NavState>().setNav(-1);
                _navController.animateToPage(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              },
              label: Text(e["section"],
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: primaryColor,
            ),
          ),
        )
        .toList();
  }

  Future _addClass(SchoolClass? schoolClass, int type) async {
    var formKey = GlobalKey<FormState>();
    int? standard;
    String? section;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                type == 0 ? const Text("Add Class") : const Text("Add Section"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  type == 0
                      ? const FormLabel(text: "Standard")
                      : const FittedBox(),
                  type == 0
                      ? const SizedBox(
                          height: 10,
                        )
                      : const FittedBox(),
                  type == 0
                      ? FormInput(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onSaved: (val) {
                            standard = int.parse(val!);
                          },
                          validator: (val) {
                            return val == null || val.isEmpty
                                ? "Enter Standard"
                                : null;
                          },
                        )
                      : Text("Class : ${schoolClass!.standard}"),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  type == 0
                      ? const FormLabel(text: "Section")
                      : const FittedBox(),
                  type == 0
                      ? const SizedBox(
                          height: 10,
                        )
                      : const FittedBox(),
                  FormInput(
                    inputFormatters: [UpperCaseFormatter()],
                    onSaved: (val) {
                      section = val;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Enter Section"
                          : null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                ),
              ),
              PrimaryButton(
                  text: "Add",
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      navBack();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (buildContext) {
                            return AlertDialog(
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
                                        "Adding Class Section",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            );
                          });
                      if (type == 0) {
                        addClass(standard!, section!, type);
                      } else {
                        addClass(schoolClass!.standard, section!, type);
                      }
                    }
                  }),
            ],
          );
        });
  }

  Future addClass(int standard, String section, int type) async {
    var body = jsonEncode({
      "school": user.school,
      "standard": standard,
      "section": section,
    });
    var res = await http.post(Uri.parse("$serverURL/addClass"),
        headers: header, body: body);

    navBack();

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      if (type == 0) {
        showSnack("Class Added", false);
      } else {
        showSnack("Section Added To Class $standard", false);
      }
      getClasses();
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

  Future _handleNav() async {
    if (currentNav != 1) {
      context.read<NavState>().setNav(1);
      _navController.animateToPage(1,
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
                        visible: currentNav == 1,
                        child: PrimaryButton(
                          text: "Add Class",
                          onPress: () {
                            _addClass(null, 0);
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
                    context.read<ActionsState>().setActions([
                      IconButton(
                          onPressed: () {
                            getClasses();
                          },
                          icon: const Icon(Icons.refresh))
                    ]);
                    _navController.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }
                },
                child: error
                    ? const ServerDown()
                    : PageView(
                        controller: _navController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _currentClass != null
                              ? ClassDetails(id: _currentClass!)
                              : const FittedBox(),
                          loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : classes.isEmpty
                                  ? const EmptyState()
                                  : Responsive.isSmall(context)
                                      ? SingleChildScrollView(
                                          controller: _scrollController,
                                          child: ExpansionPanelList(
                                            expansionCallback:
                                                (int index, bool isExpanded) {
                                              setState(() {
                                                classes[index].expanded =
                                                    !isExpanded;
                                              });
                                            },
                                            children: classes
                                                .map((e) => ExpansionPanel(
                                                      isExpanded: e.expanded,
                                                      headerBuilder:
                                                          (BuildContext context,
                                                              bool isExpanded) {
                                                        return ListTile(
                                                          title: Text(
                                                              "Class ${e.schoolClass.standard}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        );
                                                      },
                                                      body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Sections",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Wrap(
                                                              children:
                                                                  _buildChips(e
                                                                      .schoolClass
                                                                      .classes),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Center(
                                                              child:
                                                                  SecondaryButton(
                                                                text:
                                                                    "Add Section",
                                                                onPress: () {
                                                                  _addClass(
                                                                      e.schoolClass,
                                                                      1);
                                                                },
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
                                          builder:
                                              (buildContext, boxConstraints) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: boxConstraints
                                                        .minWidth),
                                                child: SingleChildScrollView(
                                                  child: DataTable(
                                                    columnSpacing: 10,
                                                    showBottomBorder: true,
                                                    columns: const [
                                                      DataColumn(
                                                          label: Text("Class")),
                                                      DataColumn(
                                                          label:
                                                              Text("Section")),
                                                    ],
                                                    rows: _buildRows(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                        ],
                      ),
              ),
            ))
          ],
        ),
        floatingActionButton: Responsive.isSmall(context)
            ? AnimatedScale(
                scale: error || loading
                    ? 0
                    : currentNav != 1
                        ? 0
                        : fabVisible
                            ? 1
                            : 0,
                duration: const Duration(milliseconds: 100),
                child: FloatingActionButton(
                  backgroundColor: primaryDarkColor,
                  onPressed: () {
                    _addClass(null, 0);
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
