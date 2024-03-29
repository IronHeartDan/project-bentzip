import 'package:bentzip/states/nav_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/MenuModel.dart';
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
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late int selected;

  @override
  void initState() {
    selected = widget.prev;
    super.initState();
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
                  itemCount: sideNav.length,
                  itemBuilder: (context, index) {
                    MenuModel menu = sideNav[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 46),
                      child: ListTile(
                        onTap: index == sideNav.length - 1
                            ? () async {
                          await secureStorage.delete(key: "token");
                          if(!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const AuthScreen()),
                                  (route) => false);
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
