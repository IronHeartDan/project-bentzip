import 'dart:convert';

import 'package:bentzip/states/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/school.dart';
import 'constants.dart';

class Api {
  static late String token;

  static Future<bool> saveSchool(BuildContext context, School school) async {
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
                      "Adding School",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ],
                )),
          );
        });

    await Future.delayed(const Duration(seconds: 2));

    var body = jsonEncode(school.toJson());
    var header = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    var res = await http.post(Uri.parse("$serverURL/addSchool"),
        headers: header, body: body);


    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("School Added"),
        duration: Duration(seconds: 5),
      ));
      return true;
    }

    var resBody = jsonDecode(res.body);

    if (res.statusCode == 400) {
      if (resBody["keyPattern"]["_id"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("School Code Already Exists"),
          backgroundColor: Colors.red,
        ));
        return false;
      }

      if (resBody["keyPattern"]["email"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email Already Exists"),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Try Again"),
      duration: Duration(seconds: 5),
    ));

    return false;
  }
}
