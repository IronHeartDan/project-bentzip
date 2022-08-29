import 'package:bentzip/widgets/form_input.dart';
import 'package:bentzip/widgets/form_label.dart';
import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:flutter/material.dart';

class AddSchoolForm extends StatefulWidget {
  const AddSchoolForm({Key? key}) : super(key: key);

  @override
  State<AddSchoolForm> createState() => _AddSchoolFormState();
}

class _AddSchoolFormState extends State<AddSchoolForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
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
                const SizedBox(
                  width: 24,
                ),
                Expanded(
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
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(text: "School id *"),
                          const SizedBox(
                            height: 16,
                          ),
                          FormInput(
                            label: "",
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
            Row(
              children: [
                Expanded(
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
                const SizedBox(
                  width: 24,
                ),
                Expanded(
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
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
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
