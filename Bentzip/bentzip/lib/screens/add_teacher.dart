import 'dart:convert';

import 'package:bentzip/models/user.dart';
import 'package:bentzip/states/user_state.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../states/nav_title_state.dart';
import '../utils/responsive.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_buttton.dart';

class AddTeacher extends StatefulWidget {
  final Function handleNav;

  const AddTeacher({Key? key, required this.handleNav}) : super(key: key);

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  List<DropdownMenuItem<Object>>? statesList;
  List<DropdownMenuItem<Object>>? citiesList;

  String currentState = "";
  String currentCity = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _editingControllerDoi = TextEditingController();
  final TextEditingController _editingControllerPass = TextEditingController();
  final TextEditingController _editingControllerStart = TextEditingController();
  final TextEditingController _editingControllerEnd = TextEditingController();
  final Map<String, dynamic> input = {};

  late User user;
  late Map<String, String> header;

  @override
  void initState() {
    context.read<NavTitleState>().setNavTitle("Add Teacher");
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    getStates();
    super.initState();
  }

  Future getStates() async {
    var states = await csc.getStatesOfCountry("IN");

    statesList = states
        .map((e) => DropdownMenuItem<String>(
              value: e.isoCode,
              child: Text(e.name),
            ))
        .toList(growable: true);

    statesList?.insert(
        0,
        const DropdownMenuItem<String>(
            value: "0", child: Text("Select State")));
    currentState = "0";
    setState(() {});
  }

  Future getCities(String stateCode) async {
    var cities = await csc.getStateCities("IN", stateCode);
    citiesList = cities
        .map((e) => DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name),
            ))
        .toList(growable: true);

    citiesList?.insert(0,
        const DropdownMenuItem<String>(value: "0", child: Text("Select City")));
    currentCity = "0";
    setState(() {});
  }

  Future _addTeacher() async {
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
                      "Adding Teacher",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ],
                )),
          );
        });
    var res = await http.post(Uri.parse("$serverURL/addTeacher"),
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
              title: const Text("Teacher-ID Generated"),
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
      showSnack("Teacher Added", false);
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
                                        label: "William",
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
                                    bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val);
                                    if (!emailValid) {
                                      return "Invalid Email";
                                    }
                                    return null;
                                  },
                                  label: "Samantha@mail.com",
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
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
                                  label: "+91**********",
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
                                  maxLines: 3,
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
                                const FormLabel(text: "Teacher Password *"),
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
                    "Education",
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
                                  const FormLabel(text: "University *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["education"] = [
                                        {
                                          "institution": val,
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
                                  const FormLabel(text: "Degree *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["education"][0]["qualification"] =
                                          val;
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
                                  const FormLabel(text: "Start Date *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.none,
                                    textEditingController:
                                        _editingControllerStart,
                                    onSaved: (val) {
                                      input["education"][0]["start"] = val;
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    label: DateFormat("yyyy-MM-dd")
                                        .format(DateTime.now())
                                        .toString(),
                                    onTap: () async {
                                      var start = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now());
                                      if (start != null) {
                                        _editingControllerStart.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(start);
                                      }
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
                                  const FormLabel(text: "End Date *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textEditingController:
                                        _editingControllerEnd,
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      input["education"][0]["end"] = val;
                                    },
                                    onTap: () async {
                                      var start = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now());
                                      if (start != null) {
                                        _editingControllerEnd.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(start);
                                      }
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
                                  const FormLabel(text: "State *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownButtonFormField(
                                      onSaved: (val) {
                                        input["education"][0]["state"] = val;
                                      },
                                      validator: (val) {
                                        if (val == null || val == "0") {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                          label: Text("Select State"),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      value: currentState,
                                      items: statesList,
                                      onChanged: (state) {
                                        setState(() {
                                          currentState = state as String;
                                        });
                                        getCities(state as String);
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
                                  const FormLabel(text: "City *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownButtonFormField(
                                      onSaved: (val) {
                                        input["education"][0]["city"] = val;
                                      },
                                      validator: (val) {
                                        if (val == null || val == "0") {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                          label: Text("Select City"),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)))),
                                      value: currentCity,
                                      items: citiesList,
                                      onChanged: (city) {
                                        setState(() {
                                          currentCity = city as String;
                                        });
                                      }),
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
                                    input["role"] = 1;
                                    _addTeacher();
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
