import 'package:bentzip/models/user.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:bentzip/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/menu_model.dart';
import '../screens/auth_screen.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatefulWidget {
  final bool hide;
  final int prev;

  const CustomDrawer({Key? key, required this.hide, required this.prev})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late int selected;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late User user;
  late int length;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    length = user.role == 0
        ? adminSideNav.length
        : user.role == 1
            ? teacherSideNav.length
            : studentSideNav.length;
    selected = widget.prev;
    super.initState();
  }

  Future _signOut() async {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: const Text("Sign Out ?"),
            actions: [
              TextButton(
                onPressed: () async {
                  context.read<NavState>().setNav(0);
                  await secureStorage.delete(key: "user");
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                      (route) => false);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  navBack();
                },
                child: const Text(
                  "No",
                ),
              )
            ],
          );
        });
  }

  void navBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavState, int>(builder: (blocContext, state) {
      if (state != -1) selected = state;
      return Drawer(
        elevation: 0,
        backgroundColor: HexColor("#3D3774"),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    MenuModel menu = user.role == 0
                        ? adminSideNav[index]
                        : user.role == 1
                            ? teacherSideNav[index]
                            : studentSideNav[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(
                          left: 46, bottom: index == length - 1 ? 30 : 0),
                      child: ListTile(
                        onTap: index == length - 1
                            ? () {
                                _signOut();
                              }
                            : () {
                                context.read<NavState>().setNav(index);
                                if (widget.hide) {
                                  Navigator.of(context).pop();
                                }
                              },
                        horizontalTitleGap: 0,
                        tileColor: Colors.transparent,
                        iconColor: secondaryColor,
                        textColor: secondaryColor,
                        selected: index == selected,
                        selectedTileColor: secondaryColor,
                        selectedColor: primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40))),
                        mouseCursor: SystemMouseCursors.click,
                        leading: Icon(menu.icon),
                        title: Text(menu.title),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
