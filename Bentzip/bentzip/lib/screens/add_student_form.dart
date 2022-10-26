import 'package:bentzip/models/school.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../utils/responsive.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_buttton.dart';

class AddStudentForm extends StatefulWidget {
  final Function handleNav;

  const AddStudentForm({Key? key, required this.handleNav}) : super(key: key);

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  List<DropdownMenuItem<Object>>? statesList;
  List<DropdownMenuItem<Object>>? citiesList;

  String currentState = "";
  String currentCity = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _editingControllerDoi = TextEditingController();
  final School _school = School();

  @override
  void initState() {
    super.initState();
    getStates();
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
                                              _school.name = val;
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
                                              _school.name = val;
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
                                        _school.name = val;
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
                                        _school.name = val;
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
                                        _school.name = val;
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
                                      onTap: () async {
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now());
                                        // if (doi != null) {
                                        //   _editingControllerDoi.text =
                                        //       DateFormat("yyyy-MM-dd")
                                        //           .format(doi);
                                        // }
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
                                  children: const [
                                    FormLabel(text: "Teacher Password *"),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    FormInput(
                                      textInputAction: TextInputAction.next,
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
                                  children: const [
                                    FormLabel(text: "Confirm Password *"),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    FormInput(
                                      textInputAction: TextInputAction.done,
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
              // const SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: 50,
              //   ),
              // ),
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
                                      _school.name = val;
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
                                      _school.name = val;
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
                          direction: MediaQuery.of(context).size.width < 1200
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: MediaQuery.of(context).size.width < 1200
                                    ? 0
                                    : 1,
                                child: Flex(
                                  direction:
                                  MediaQuery.of(context).size.width < 1200
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: MediaQuery.of(context).size.width <
                                          1200
                                          ? 0
                                          : 1,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const FormLabel(text: "Start Date *"),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormInput(
                                            textInputAction:
                                            TextInputAction.next,
                                            textInputType: TextInputType.none,
                                            textEditingController:
                                            _editingControllerDoi,
                                            onSaved: (val) {
                                              _school.doi = val;
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
                                              var doi = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now());
                                              if (doi != null) {
                                                _editingControllerDoi.text =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(doi);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                      Responsive.isSmall(context) ? 0 : 24,
                                      height:
                                      Responsive.isSmall(context) ? 24 : 0,
                                    ),
                                    Expanded(
                                      flex: MediaQuery.of(context).size.width <
                                          1200
                                          ? 0
                                          : 1,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const FormLabel(text: "End Date *"),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          FormInput(
                                            textInputAction:
                                            TextInputAction.next,
                                            onSaved: (val) {
                                              _school.id = val;
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
                                )),
                            SizedBox(
                              width: Responsive.isSmall(context) ? 0 : 24,
                              height: Responsive.isSmall(context) ? 24 : 0,
                            ),
                            Expanded(
                              flex: MediaQuery.of(context).size.width < 1200
                                  ? 0
                                  : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "Contact Number *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
                                    onSaved: (val) {
                                      _school.contact = val;
                                    },
                                    validator: (val) {
                                      if (val == null || val.isEmpty)
                                        return "Required";
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
                                  if (_formKey.currentState!.validate()) {}
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
