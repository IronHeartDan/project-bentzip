import 'package:bentzip/widgets/primary_buttton.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../utils/responsive.dart';

class SchoolsTable extends StatefulWidget {
  const SchoolsTable({Key? key}) : super(key: key);

  @override
  State<SchoolsTable> createState() => _SchoolsTableState();
}

class _SchoolsTableState extends State<SchoolsTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: !Responsive.isSmall(context)
          ? const EdgeInsets.all(40)
          : const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: HexColor("#C7C7C7"),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: Row(
              children: [
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none
                      // labelText: "Search",
                      ),
                )),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    height: 50,
                    child: PrimaryButton(text: "Search", onPress: () {}))
              ],
            ),
          ),
          Expanded(child: Image.asset("assets/asset_lookup.png"))
        ],
      ),
    );
  }
}
