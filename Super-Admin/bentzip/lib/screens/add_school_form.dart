import 'package:bentzip/models/school.dart';
import 'package:bentzip/utils/api.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/form_input.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _editingControllerPass = TextEditingController();
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
    return Column(
      children: [
        Container(
          padding: !Responsive.isSmall(context)
              ? const EdgeInsets.symmetric(horizontal: 40, vertical: 5)
              : const EdgeInsets.all(10),
          width: double.infinity,
          color: primaryColor,
          child: Text(
            "School Details",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          controller: ScrollController(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: !Responsive.isSmall(context)
                  ? const EdgeInsets.only(left: 40,right: 40,bottom: 40,top: 10)
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
                                if (val == null || val.isEmpty)
                                  return "Required";
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
                                if (val == null || val.isEmpty)
                                  return "Required";
                                return null;
                              },
                              label: "William",
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
                                flex: MediaQuery.of(context).size.width < 1200
                                    ? 0
                                    : 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                              SizedBox(
                                width: Responsive.isSmall(context) ? 0 : 24,
                                height: Responsive.isSmall(context) ? 24 : 0,
                              ),
                              Expanded(
                                flex: MediaQuery.of(context).size.width < 1200
                                    ? 0
                                    : 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                      SizedBox(
                        width: Responsive.isSmall(context) ? 0 : 24,
                        height: Responsive.isSmall(context) ? 24 : 0,
                      ),
                      Expanded(
                        flex:
                            MediaQuery.of(context).size.width < 1200 ? 0 : 1,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: Responsive.isSmall(context) ? 0 : 1,
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
                                if (val == null || val.isEmpty)
                                  return "Required";
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
                      SizedBox(
                        width: Responsive.isSmall(context) ? 0 : 24,
                        height: Responsive.isSmall(context) ? 24 : 0,
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
                              textInputAction: TextInputAction.next,
                              onSaved: (val) {
                                _school.address = val;
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return "Required";
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                            )
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
                            const FormLabel(text: "Admin Password *"),
                            const SizedBox(
                              height: 16,
                            ),
                            FormInput(
                              textEditingController: _editingControllerPass,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return "Required";
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
                              obscureText: true,
                              onSaved: (val) {
                                _school.password = val;
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return "Required";
                                if (val != _editingControllerPass.text)
                                  return "Password Doesn't Match";
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
                  Row(
                    children: [
                      PrimaryButton(
                        text: "Add",
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _school.active = true;
                            var saved =
                                await Api.saveSchool(context, _school);
                            if (!mounted) return;
                            Navigator.pop(context);
                            if (saved) {
                              widget.handleNav();
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
        )),
      ],
    );
  }
}
