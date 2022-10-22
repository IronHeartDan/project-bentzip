import 'dart:convert';

import 'package:bentzip/models/school.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/form_input.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddSchoolForm extends StatefulWidget {
  final Function handleNav;

  const AddSchoolForm({Key? key, required this.handleNav}) : super(key: key);

  @override
  State<AddSchoolForm> createState() => _AddSchoolFormState();
}

class _AddSchoolFormState extends State<AddSchoolForm> {
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

  Future<bool> _saveSchool() async {
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
                      "Adding School",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ],
                )),
          );
        });

    await Future.delayed(const Duration(seconds: 2));

    var body = jsonEncode(_school.toJson());
    var res = await http.post(Uri.parse("$serverURL/addSchool"),
        headers: {"Content-Type": "application/json"}, body: body);

    return res.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: !Responsive.isSmall(context)
            ? const EdgeInsets.all(40)
            : const EdgeInsets.all(10),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flex(
                  direction: Responsive.isSmall(context)
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    Expanded(
                      flex: Responsive.isSmall(context) ? 0 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(text: "School name *"),
                          const SizedBox(
                            height: 16,
                          ),
                          FormInput(
                            textInputAction: TextInputAction.next,
                            onSaved: (val) {
                              _school.name = val;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Required";
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
                          const FormLabel(text: "School email id *"),
                          const SizedBox(
                            height: 16,
                          ),
                          FormInput(
                            textInputAction: TextInputAction.next,
                            onSaved: (val) {
                              _school.email = val;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Required";
                              return null;
                            },
                            label: "William",
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
                  children: [
                    Expanded(
                        flex: Responsive.isSmall(context) ? 0 : 1,
                        child: Flex(
                          direction: Responsive.isSmall(context)
                              ? Axis.vertical
                              : Axis.horizontal,
                          children: [
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(
                                      text: "Date of Incorporation *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
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
                            const SizedBox(
                              width: 24,
                            ),
                            Expanded(
                              flex: Responsive.isSmall(context) ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FormLabel(text: "School code *"),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FormInput(
                                    textInputAction: TextInputAction.next,
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
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      flex: Responsive.isSmall(context) ? 0 : 1,
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
                              if (val == null || val.isEmpty) return "Required";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(text: "Principal Name *"),
                          const SizedBox(
                            height: 16,
                          ),
                          FormInput(
                            textInputAction: TextInputAction.next,
                            onSaved: (val) {
                              _school.principal = val;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Required";
                              return null;
                            },
                            label: "Samantha",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(text: "Website URL *"),
                          const SizedBox(
                            height: 16,
                          ),
                          FormInput(
                            textInputAction: TextInputAction.next,
                            onSaved: (val) {
                              _school.website = val;
                            },
                            validator: (val) {
                              return null;
                            },
                            label: "https://school.com",
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
                                _school.state = val?.toString();
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
                    const SizedBox(
                      width: 24,
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
                                _school.city = val?.toString();
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
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      flex: Responsive.isSmall(context) ? 0 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(text: "Address *"),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onSaved: (val) {
                              _school.address = val;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Required";
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    PrimaryButton(
                      text: "Add",
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _school.active = true;
                          var saved = await _saveSchool();
                          if (saved) {
                            if (!mounted) return;
                            Navigator.pop(context);
                            widget.handleNav();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("School Added"),
                              duration: Duration(seconds: 5),
                            ));
                          } else {
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Try Again"),
                              duration: Duration(seconds: 5),
                            ));
                          }
                        }
                      },
                      icon: Icons.add,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
