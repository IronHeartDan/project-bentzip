import 'package:bentzip/models/user.dart';
import 'package:bentzip/states/user_state.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late User user;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user.assignedClass == null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Responsive.isSmall(context)
                ? null
                : const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Image.asset(
                  "assets/asset_null_class.png",
                )),
            const SizedBox(
              height: 20,
            ),
            Text(
              "No Class Assigned",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 24),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Responsive.isSmall(context)
              ? null
              : const BorderRadius.all(Radius.circular(20))),
    );
  }
}
