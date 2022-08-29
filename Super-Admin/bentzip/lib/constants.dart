import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'models/MenuModel.dart';

final primaryColor =  HexColor("#3D3774");
final secondaryColor =  HexColor("#F3F4FF");
final secondaryDarkColor =  HexColor("#C1BBEB");
final secondaryTextColor =  HexColor("#A098AE");

final sideNavs = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.add_box_outlined, "Add School"),
  MenuModel(Icons.payment, "Payment"),
  MenuModel(Icons.airplane_ticket, "Support Ticket"),
  MenuModel(Icons.analytics, "Report"),
];