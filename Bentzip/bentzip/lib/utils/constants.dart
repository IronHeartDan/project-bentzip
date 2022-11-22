import 'package:bentzip/screens/notice_screen.dart';
import 'package:bentzip/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/menu_model.dart';
import '../screens/attendance_screen.dart';
import '../screens/class_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/leaves_screen.dart';
import '../screens/student_screen.dart';
import '../screens/teachers_screen.dart';

final primaryColor = HexColor("#3D3774");
final primaryDarkColor = HexColor("#170F49");
final secondaryColor = HexColor("#F3F4FF");
final secondaryDarkColor = HexColor("#C1BBEB");
final secondaryTextColor = HexColor("#A098AE");

final orange = HexColor("#FB7D5B");
final yellow = HexColor("#FCC43E");
final green = HexColor("#219653");
final red = HexColor("#F90706");

final roles = ["Admin", "Teacher", "Student"];

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

final adminSideScreens = [
  const DashBoardScreen(),
  const ClassScreen(),
  const TeachersScreen(),
  const StudentScreen(),
  const AttendanceScreen(),
  const NoticeScreen(),
  const LeavesScreen(),
  const FittedBox(),
];

final teacherSideNav = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.account_circle, "Profile"),
  MenuModel(Icons.add_box_outlined, "Attendance"),
  MenuModel(Icons.add_box_outlined, "Leave Approval"),
  MenuModel(Icons.power_settings_new, "Sign Out")
];

final teacherSideScreens = [
  const DashBoardScreen(),
  const ProfileScreen(),
  const FittedBox(),
  const FittedBox(),
];

final studentSideNav = [
  MenuModel(Icons.dashboard, "Dashboard"),
  MenuModel(Icons.account_circle, "Profile"),
  MenuModel(Icons.add_box_outlined, "Attendance"),
  MenuModel(Icons.power_settings_new, "Sign Out")
];

final studentSideScreens = [
  const DashBoardScreen(),
  const ProfileScreen(),
  const FittedBox(),
  const FittedBox(),
];

// const String serverURL = "http://192.168.1.38:3001";
const String serverURL = "https://bentzip.herokuapp.com";
