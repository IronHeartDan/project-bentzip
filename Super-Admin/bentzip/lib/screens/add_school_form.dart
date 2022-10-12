import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/form_input.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';

class AddSchoolForm extends StatefulWidget {
  const AddSchoolForm({Key? key}) : super(key: key);

  @override
  State<AddSchoolForm> createState() => _AddSchoolFormState();
}

class _AddSchoolFormState extends State<AddSchoolForm> {
  List<DropdownMenuItem<Object>>? statesList;
  List<DropdownMenuItem<Object>>? citiesList;

  String currentState = "";
  String currentCity = "";

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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: !Responsive.isSmall(context)
          ? const EdgeInsets.all(40)
          : const EdgeInsets.all(10),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Flex(
              direction:
                  Responsive.isSmall(context) ? Axis.vertical : Axis.horizontal,
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
              direction:
                  Responsive.isSmall(context) ? Axis.vertical : Axis.horizontal,
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
                              const FormLabel(text: "Date of Incorporation *"),
                              const SizedBox(
                                height: 16,
                              ),
                              FormInput(
                                label: "+1234567890",
                                onTap: () async {
                                  await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now());
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
                              FormInput(),
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
                      FormInput(),
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
                        label: "https://",
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
              direction:
                  Responsive.isSmall(context) ? Axis.vertical : Axis.horizontal,
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
                          isExpanded: true,
                          decoration: const InputDecoration(
                              label: Text("Select State"),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
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
                          isExpanded: true,
                          decoration: const InputDecoration(
                              label: Text("Select City"),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
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
                  onPress: () {},
                  icon: Icons.add,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
