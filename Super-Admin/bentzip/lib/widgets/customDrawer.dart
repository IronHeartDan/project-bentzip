import 'package:bentzip/states/nav_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constants.dart';
import '../models/MenuModel.dart';

class CustomDrawer extends StatefulWidget {
  final bool hide;

  const CustomDrawer({Key? key, required this.hide}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavState, int>(builder: (blocContext, state) {
      return Drawer(
        elevation: 0,
        backgroundColor: HexColor("#3D3774"),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: const Icon(Icons.logo_dev),
              titleSpacing: 0,
              title: const Text("Bentzip"),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: sideNavs.length,
                  itemBuilder: (context, index) {
                    MenuModel menu = sideNavs[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 46),
                      child: ListTile(
                        onTap: () {
                          context.read<NavState>().setNav(index);
                          if (widget.hide) {
                            Navigator.of(context).pop();
                          }
                        },
                        horizontalTitleGap: 0,
                        tileColor: Colors.transparent,
                        iconColor: secondaryColor,
                        textColor: secondaryColor,
                        selected: index == state,
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
