import 'dart:convert';

import 'package:bentzip/models/school_class.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../models/user.dart';
import '../states/nav_title_state.dart';
import '../states/user_state.dart';
import '../utils/responsive.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_buttton.dart';

class AddStudent extends StatefulWidget {
  final Function handleNav;

  const AddStudent({Key? key, required this.handleNav}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  late List<SchoolClass> _classes;

  List<DropdownMenuItem<Object>>? classesList;
  List<DropdownMenuItem<Object>>? sectionsList;

  String currentClass = "";
  String currentSection = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _editingControllerDoi = TextEditingController();
  final TextEditingController _editingControllerPass = TextEditingController();
  final Map<String, dynamic> input = {};

  late User user;
  late Map<String, String> header;

  @override
  void initState() {
    context.read<NavTitleState>().setNavTitle("Add Student");
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    getClasses();
    super.initState();
  }

  Future getClasses() async {
    var header = {
      "Content-Type": "application/json",
      "Authorization": context.read<UserState>().state!.token,
    };

    var res = await http.get(
        Uri.parse(
            "$serverURL/getClasses?school=${context.read<UserState>().state!.school}"),
        headers: header);
    if (res.statusCode == 400) return;
    var resBody = jsonDecode(res.body);
    if (resBody.isEmpty) {
      widget.handleNav();
      showSnack("Please Add Classes", true);
      return;
    }

    _classes = (resBody as List).map((e) => SchoolClass.fromJson(e)).toList();

    classesList = _classes
        .map((e) => DropdownMenuItem<String>(
              value: e.standard.toString(),
              child: Text(e.standard.toString()),
            ))
        .toList(growable: true);

    classesList?.insert(
        0,
        const DropdownMenuItem<String>(
            value: "0", child: Text("Select Class")));
    currentClass = "0";
    setState(() {});
  }

  Future _getDivisions() async {
    var index = _classes
        .indexWhere((element) => element.standard == int.parse(currentClass));
    sectionsList = _classes[index]
        .classes
        .map((e) => DropdownMenuItem<String>(
              value: e["section"],
              child: Text(e["section"]),
            ))
        .toList(growable: true);
    sectionsList?.insert(
        0,
        const DropdownMenuItem<String>(
            value: "0", child: Text("Select Section")));
    currentSection = "0";
    setState(() {});
  }

  Future _addStudent() async {
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
                      "Adding Student",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ],
                )),
          );
        });
    var res = await http.post(Uri.parse("$serverURL/addStudent"),
        headers: header, body: jsonEncode(input));

    navBack();

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      await showDialog(
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              title: const Text("Student-ID Generated"),
              content: TextFormField(
                initialValue: res.body,
                readOnly: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: res.body));
                      showSnack("Copied To Clipboard", false);
                      navBack();
                    },
                    child: const Text("Copy")),
                TextButton(
                    onPressed: () {
                      navBack();
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            );
          });
      showSnack("Student Added", false);
      widget.handleNav();
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              MultiSliver(pushPinnedChildren: true, children: [
                SliverPinnedHeader(
                    child: Container(
                  padding: !Responsive.isSmall(context)
                      ? const EdgeInsets.symmetric(horizontal: 40, vertical: 10)
                      : const EdgeInsets.all(10),
                  color: primaryColor,
                  child: Text(
                    "Personal Details",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: !Responsive.isSmall(context)
                      ? const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40, top: 10)
                      : const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Flex(
                        direction: Responsive.isSmall(context)
                            ? Axis.vertical
                            : Axis.horizontal,
                        crossAxisAlignment: Responsive.isSmall(context)
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormLabel(text: "Photo *"),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: const Center(
                                    child: Text(
                                  "Click Here To Select Image",
                                  textAlign: TextAlign.center,
                                )),
                              )
                            ],
                          ),
                          SizedBox(
                            width: Responsive.isSmall(context) ? 0 : 30,
                            height: Responsive.isSmall(context) ? 30 : 0,
                          ),
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Flex(
                              direction: Responsive.isSmall(context)
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: Responsive.isSmall(context) ? 0 : 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FormLabel(text: "First name *"),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      FormInput(
                                        textInputAction: TextInputAction.next,
                                        onSaved: (val) {
                                          input["name"] = val;
                                        },
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                        label: "Samantha",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.isSmall(context) ? 0 : 24,
                                  height: Responsive.isSmall(context) ? 24 : 0,
                                ),
                                Expanded(
                                  flex: Responsive.isSmall(context) ? 0 : 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FormLabel(text: "Last name *"),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      FormInput(
                                        textInputAction: TextInputAction.next,
                                        onSaved: (val) {
                                          input["name"] += " $val";
                                        },
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                        label: "Samantha",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Flex(
                        direction: Responsive.isSmall(context)
                            ? Axis.vertical
                            : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Email *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (val) {
                                    input["email"] = val;
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  label: "Samantha",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isSmall(context) ? 0 : 24,
                            height: Responsive.isSmall(context) ? 24 : 0,
                          ),
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Phone *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (val) {
                                    input["contact"] = [val];
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  label: "Samantha",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Flex(
                        direction: Responsive.isSmall(context)
                            ? Axis.vertical
                            : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Address *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  onSaved: (val) {
                                    input["address"] = val;
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isSmall(context) ? 0 : 24,
                            height: Responsive.isSmall(context) ? 24 : 0,
                          ),
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Date Of Birth *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _editingControllerDoi,
                                  onSaved: (val) {
                                    input["dob"] = val;
                                  },
                                  onTap: () async {
                                    var doi = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    if (doi != null) {
                                      _editingControllerDoi.text =
                                          DateFormat("yyyy-MM-dd").format(doi);
                                    }
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  label: "Samantha",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isSmall(context) ? 24 : 30,
                      ),
                      Flex(
                        direction: Responsive.isSmall(context)
                            ? Axis.vertical
                            : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Student Password *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  textEditingController: _editingControllerPass,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (val) {
                                    input["password"] = val;
                                  },
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  label: "Create Password",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isSmall(context) ? 0 : 24,
                            height: Responsive.isSmall(context) ? 24 : 0,
                          ),
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Confirm Password *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                FormInput(
                                  textInputAction: TextInputAction.done,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Required";
                                    }

                                    if (_editingControllerPass.text != val) {
                                      return "Password Don't Match";
                                    }

                                    return null;
                                  },
                                  label: "Check",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isSmall(context) ? 24 : 30,
                      ),
                      Flex(
                        direction: Responsive.isSmall(context)
                            ? Axis.vertical
                            : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Select Class *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                DropdownButtonFormField(
                                    onSaved: (val) {},
                                    validator: (val) {
                                      if (val == null || val == "0") {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                        label: Text("Select Class"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    value: currentClass,
                                    items: classesList,
                                    onChanged: (schoolClass) {
                                      setState(() {
                                        currentClass = schoolClass as String;
                                      });
                                      _getDivisions();
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Responsive.isSmall(context) ? 0 : 24,
                            height: Responsive.isSmall(context) ? 24 : 0,
                          ),
                          Expanded(
                            flex: Responsive.isSmall(context) ? 0 : 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FormLabel(text: "Select Section *"),
                                const SizedBox(
                                  height: 16,
                                ),
                                DropdownButtonFormField(
                                    onSaved: (val) {},
                                    validator: (val) {
                                      if (val == null || val == "0") {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                        label: Text("Select Section"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    value: currentSection,
                                    items: sectionsList,
                                    onChanged: (section) {
                                      setState(() {
                                        currentSection = section as String;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ]),
              MultiSliver(pushPinnedChildren: true, children: [
                SliverPinnedHeader(
                    child: Container(
                  color: primaryColor,
                  padding: !Responsive.isSmall(context)
                      ? const EdgeInsets.symmetric(horizontal: 40, vertical: 10)
                      : const EdgeInsets.all(10),
                  child: Text(
                    "Guardian",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: !Responsive.isSmall(context)
                        ? const EdgeInsets.only(
                            left: 40, right: 40, bottom: 40, top: 10)
                        : const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Flex(
                          direction: Responsive.isSmall(context)
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "First Name *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["guardian"] = [
                                        {
                                          "name": val,
                                        }
                                      ];
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    label: "Samantha",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Responsive.isSmall(context) ? 0 : 24,
                              height: Responsive.isSmall(context) ? 24 : 0,
                            ),
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "Last Name *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["guardian"][0]["name"] += " $val";
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    label: "Samantha",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.isSmall(context) ? 24 : 30,
                        ),
                        Flex(
                          direction: Responsive.isSmall(context)
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "Address *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["guardian"][0]["address"] = val;
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    label: "Samantha",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Responsive.isSmall(context) ? 0 : 24,
                              height: Responsive.isSmall(context) ? 24 : 0,
                            ),
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "Phone *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.done,
                                    onSaved: (val) {
                                      input["guardian"][0]["contact"] = val;
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    label: "Samantha",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.isSmall(context) ? 24 : 30,
                        ),
                        Flex(
                          direction: Responsive.isSmall(context)
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: Responsive.isSmall(context)
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child:
                                      Image.asset("assets/asset_teacher.png")),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 150,
                              ),
                              child: PrimaryButton(
                                text: "Add",
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    input["school"] = user.school;
                                    input["role"] = 2;
                                    var classIndex = _classes.indexWhere(
                                        (element) =>
                                            element.standard ==
                                            int.parse(currentClass));
                                    var secIndex = _classes[classIndex]
                                        .classes
                                        .indexWhere((element) =>
                                            element["section"] ==
                                            currentSection);
                                    input["class"] = _classes[classIndex]
                                        .classes[secIndex]["id"];
                                    _addStudent();
                                  }
                                },
                                icon: Icons.add,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
