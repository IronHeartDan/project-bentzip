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

final sideNav = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.add_box_outlined, "Add School"),
  MenuModel(Icons.payment, "Payment"),
  MenuModel(Icons.airplane_ticket, "Support Ticket"),
  MenuModel(Icons.analytics, "Report"),
  MenuModel(Icons.power_settings_new, "Sign Out")
];

const String serverURL = "http://192.168.1.36:3000";
