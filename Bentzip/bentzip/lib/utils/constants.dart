import 'package:bentzip/screens/class_leaves_management.dart';
import 'package:bentzip/screens/manage_class.dart';
import 'package:bentzip/screens/notice_screen.dart';
import 'package:bentzip/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/menu_model.dart';
import '../screens/admin_leaves_management.dart';
import '../screens/attendance_screen.dart';
import '../screens/class_screen.dart';
import '../screens/dashboard_screen.dart';
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
  MenuModel(Icons.dashboard, "Dashboard", false),
  MenuModel(Icons.meeting_room, "Classes", true),
  MenuModel(Icons.supervised_user_circle, "Teachers", false),
  MenuModel(Icons.people, "Students", false),
  MenuModel(Icons.notifications_active, "Notices", true),
  MenuModel(Icons.grading, "Leave Approval", true),
  MenuModel(Icons.power_settings_new, "Sign Out", false)
];

final adminSideScreens = [
  const DashBoardScreen(),
  const ClassScreen(),
  const TeachersScreen(),
  const StudentScreen(),
  const NoticeScreen(),
  const AdminLeavesManagement(),
];

final teacherSideNav = [
  MenuModel(Icons.dashboard, "Dashboard", false),
  MenuModel(Icons.account_circle, "Profile", false),
  MenuModel(Icons.add_box_outlined, "Attendance", false),
  MenuModel(Icons.meeting_room, "Class", false),
  MenuModel(Icons.notifications_active, "Notices", true),
  MenuModel(Icons.grading, "Leave Approval", true),
  MenuModel(Icons.power_settings_new, "Sign Out", false)
];

final teacherSideScreens = [
  const DashBoardScreen(),
  const ProfileScreen(),
  const AttendanceScreen(),
  const ManageClass(),
  const NoticeScreen(),
  const ClassLeavesManagement(),
];

final studentSideNav = [
  MenuModel(Icons.dashboard, "Dashboard", false),
  MenuModel(Icons.account_circle, "Profile", false),
  MenuModel(Icons.add_box_outlined, "Attendance", false),
  MenuModel(Icons.notifications_active, "Notices", true),
  MenuModel(Icons.power_settings_new, "Sign Out", false)
];

final studentSideScreens = [
  const DashBoardScreen(),
  const ProfileScreen(),
  const AttendanceScreen(),
  const NoticeScreen(),
];

// const String serverURL = "http://192.168.1.36:3001";
const String serverURL = "https://api.bentzip.com";