import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../models/MenuModel.dart';

final primaryColor = HexColor("#3D3774");
final primaryDarkColor = HexColor("#170F49");
final secondaryColor = HexColor("#F3F4FF");
final secondaryDarkColor = HexColor("#C1BBEB");
final secondaryTextColor = HexColor("#A098AE");

final orange = HexColor("#FB7D5B");
final yellow = HexColor("#FCC43E");
final green = HexColor("#219653");
final red = HexColor("#F90706");


final roles = ["Admin","Teacher","Student"];

final adminSideNav = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.add_box_outlined, "Classes"),
  MenuModel(Icons.add_box_outlined, "Teachers"),
  MenuModel(Icons.add_box_outlined, "Students"),
  MenuModel(Icons.add_box_outlined, "Attendance"),
  MenuModel(Icons.add_box_outlined, "Notices"),
  MenuModel(Icons.add_box_outlined, "Leave Approval"),
  MenuModel(Icons.add_box_outlined, "Fee Management"),
  MenuModel(Icons.power_settings_new, "Sign Out")
];

final teacherSideNav = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.add_box_outlined, "Attendance"),
  MenuModel(Icons.add_box_outlined, "Leave Approval"),
  MenuModel(Icons.power_settings_new, "Sign Out")
];

final studentSideNav = [
  MenuModel(Icons.power_settings_new, "Sign Out")
];

const String serverURL = "http://192.168.1.38:3001";
