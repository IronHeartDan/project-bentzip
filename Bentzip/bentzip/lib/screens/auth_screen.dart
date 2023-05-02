import 'dart:convert';

import 'package:bentzip/models/user.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../states/user_state.dart';
import '../widgets/form_input.dart';
import '../widgets/form_label.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? userId;
  String? password;

  Future _logIn() async {
    setState(() {
      loading = true;
    });
    var body = {
      "id": int.parse(userId!),
      "password": password!,
    };

    var header = {"Content-Type": "application/json"};
    http.Response res;
    try {
      res = await http
          .post(Uri.parse("$serverURL/login"),
              headers: header, body: jsonEncode(body))
          .timeout(onTimeout: () {
        return http.Response('Timeout', 408);
      }, const Duration(seconds: 5));
    } on http.ClientException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      loading = false;
    });

    if (res.statusCode == 408) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Request Timeout"),
        backgroundColor: Colors.red,
      ));
    }

    if (res.statusCode == 200) {
      await secureStorage.write(key: "user", value: res.body);
      if (!mounted) return;
      context.read<UserState>().setUser(User.fromJson(jsonDecode(res.body)));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
      return;
    }

    if (res.statusCode == 400) {
      var resBody = jsonDecode(res.body);
      if (!mounted) return;
      if (resBody["id"] == -1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User Not Found"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      if (resBody["password"] == -1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect Password"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future _resetPassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context,setState,) {
            bool codeSent = false;
            return AlertDialog(
              title: const Text("Password Reset"),
              content: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormLabel(text: codeSent ? "Enter Code" : "User ID"),
                    const SizedBox(
                      height: 10,
                    ),
                    FormInput(
                      validator: (val) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: PrimaryButton(
                          text: "Send Code",
                          onPress: () {
                            setState(() {
                              codeSent = true;
                            });
                          }),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel")),
              ],
            );
          });
        });
  }

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
              width: !Responsive.isSmall(context) ? size.width / 2 : size.width,
              height: !Responsive.isSmall(context) ? size.height : null,
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height,
                  bottom: 20,
                  left: 20,
                  right: 20),
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
              width: !Responsive.isSmall(context) ? size.width / 2 : size.width,
              height: !Responsive.isSmall(context) ? size.height : null,
              constraints: !Responsive.isSmall(context)
                  ? const BoxConstraints(maxWidth: 600)
                  : const BoxConstraints(maxWidth: 500),
              padding: Responsive.isSmall(context)
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
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
                    const FormLabel(text: "User ID"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      onSaved: (val) {
                        userId = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Required";
                        }
                        if (val.length != 12) {
                          return "Invalid";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Enter Your UserId",
                          prefixIcon: Image.asset("assets/icon_mail.png"),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: HexColor("#EFF0F7")),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const FormLabel(text: "Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onSaved: (val) {
                        password = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Password Required";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Enter Password",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: HexColor("#EFF0F7")),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)))),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onPressed: loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _logIn();
                                  }
                                },
                          child: loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Authenticating"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text("Sign In")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        _resetPassword();
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
