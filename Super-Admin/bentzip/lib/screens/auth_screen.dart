import 'package:bentzip/screens/home_screen.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Flex(
          direction:
              Responsive.isSmall(context) ? Axis.vertical : Axis.horizontal,
          children: [
            Container(
              width: !Responsive.isSmall(context) ? size.width/2 : size.width,
              height: !Responsive.isSmall(context) ? size.height : null,
              padding:  EdgeInsets.only(top: AppBar().preferredSize.height,bottom: 20,left: 20,right: 20),
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bentzip",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 36),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/asset_edu.png",
                    width: Responsive.isSmall(context) ? 400 : null,
                  )
                ],
              ),
            ),
            Container(
              // width: Responsive.isSmall(context) ? 500 : 600,
              width: !Responsive.isSmall(context) ? size.width/2 : size.width,
              height: !Responsive.isSmall(context) ? size.height : null,
              constraints: !Responsive.isSmall(context) ? const BoxConstraints(maxWidth: 600) : const BoxConstraints(maxWidth: 500),
              padding: Responsive.isSmall(context)
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign In",
                    style: GoogleFonts.inter(
                        color: primaryDarkColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Nice to see you again!",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "User Id",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: primaryDarkColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                        labelText: "Enter Your UserId",
                        prefixIcon: Image.asset("assets/icon_mail.png"),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: HexColor("#EFF0F7")),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Password",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: primaryDarkColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                        labelText: "Enter Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: HexColor("#EFF0F7")),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        clipBehavior: Clip.hardEdge,
                        style: ElevatedButton.styleFrom(
                            foregroundColor: secondaryColor,
                            backgroundColor: primaryDarkColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 43),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                        },
                        child: const Text("Sign In")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password ?",
                      style:
                          GoogleFonts.inter(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
