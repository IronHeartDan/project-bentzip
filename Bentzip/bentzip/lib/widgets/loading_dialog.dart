import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class LoadingDialog extends StatelessWidget {
  final String detail;

  const LoadingDialog({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                  detail,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }
}
