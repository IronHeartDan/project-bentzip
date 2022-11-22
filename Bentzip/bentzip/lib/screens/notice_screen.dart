import 'dart:convert';

import 'package:bentzip/models/notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../states/actions_state.dart';
import '../states/nav_state.dart';
import '../states/user_state.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_buttton.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class Item {
  Notice notice;
  bool expanded;

  Item(this.notice, this.expanded);
}

class _NoticeScreenState extends State<NoticeScreen>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;
  late User user;
  late var header;
  late List<Item> notices;

  @override
  void initState() {
    context.read<ActionsState>().setActions([
      IconButton(
          onPressed: () {
            _getNotices();
          },
          icon: const Icon(Icons.refresh))
    ]);
    user = context.read<UserState>().state!;
    header = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    _getNotices();
    super.initState();
  }

  Future _getNotices() async {
    setState(() {
      loading = true;
    });

    var res = await http.get(
        Uri.parse("$serverURL/getNotices?school=${user.school}"),
        headers: header);

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      notices = (resBody as List)
          .map((e) => Item(Notice.fromJson(e), false))
          .toList();
    }

    setState(() {
      loading = false;
    });
  }

  List<DataRow> _buildRows() {
    return notices
        .map((item) => DataRow(cells: [
              DataCell(Text(item.notice.title)),
              DataCell(Text(item.notice.description)),
              DataCell(Text(item.notice.date)),
            ]))
        .toList();
  }

  Future _addNotice() async {
    var formKey = GlobalKey<FormState>();
    late String title;
    late String description;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notice"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel(text: "Title"),
                  const SizedBox(
                    height: 10,
                  ),
                  FormInput(
                    onSaved: (val) {
                      title = val!;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty ? "Enter Title" : null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormLabel(text: "Description"),
                  const SizedBox(
                    height: 10,
                  ),
                  FormInput(
                    onSaved: (val) {
                      description = val!;
                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Enter Description"
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
                                        "Adding Notice",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            );
                          });
                      addNotice(title, description);
                    }
                  }),
            ],
          );
        });
  }

  Future addNotice(String title, String description) async {
    var body = jsonEncode({
      "title": title,
      "description": description,
      "school": user.school,
    });
    var res = await http.post(Uri.parse("$serverURL/addNotice"),
        headers: header, body: body);

    navBack();

    if (res.statusCode == 400) {
      showSnack(res.body, true);
      return;
    }

    if (res.statusCode == 200) {
      showSnack("Notice Added", false);

      _getNotices();
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
    super.build(context);
    return BlocListener<NavState, int>(
      listener: (_, state) {
        if (state == 5) {
          context.read<ActionsState>().setActions([
            IconButton(
                onPressed: () {
                  _getNotices();
                },
                icon: const Icon(Icons.refresh))
          ]);
        }
      },
      child: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Responsive.isSmall(context)
                ? SingleChildScrollView(
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          notices[index].expanded = !isExpanded;
                        });
                      },
                      children: notices
                          .map((e) => ExpansionPanel(
                                isExpanded: e.expanded,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(e.notice.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Text(e.notice.date),
                                    leading: const Icon(Icons.notifications),
                                  );
                                },
                                body: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.notice.description),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : LayoutBuilder(
                    builder: (buildContext, boxConstraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: boxConstraints.minWidth),
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 10,
                              showBottomBorder: true,
                              columns: const [
                                DataColumn(label: Text("Title")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("Date")),
                              ],
                              rows: _buildRows(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        floatingActionButton: Responsive.isSmall(context)
            ? AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 100),
                child: FloatingActionButton(
                  backgroundColor: primaryDarkColor,
                  onPressed: () {
                    _addNotice();
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
