import 'package:bentzip/models/user.dart';
import 'package:bentzip/screens/add_class.dart';
import 'package:bentzip/screens/add_student.dart';
import 'package:bentzip/screens/add_teacher.dart';
import 'package:bentzip/screens/dashboard_screen.dart';
import 'package:bentzip/states/connection_state.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:bentzip/states/user_state.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:bentzip/widgets/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'attendance_screen.dart';
import 'payment_screen.dart';
import 'report_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController();
  ScaffoldFeatureController? connectionBar;
  String currentTitle = adminSideNav[0].title;
  int last = 0;
  late User user;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        context.read<AppConnectionState>().setConnection(true);
      } else {
        context.read<AppConnectionState>().setConnection(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConnectionState, bool>(
      listener: (_, state) {
        if (state) {
          connectionBar?.close();
        } else {
          connectionBar =
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            dismissDirection: DismissDirection.none,
            content: Text("No Internet"),
            backgroundColor: Colors.red,
            duration: Duration(days: 365),
          ));
        }
      },
      child: BlocBuilder<NavState, int>(builder: (blocContext, navState) {
        if (navState != -1) {
          last = navState;
          currentTitle = adminSideNav[navState].title;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: Responsive.isSmall(context)
              ? AppBar(
                  elevation: 0,
                  backgroundColor: primaryColor,
                  leading: navState == -1
                      ? InkWell(
                          onTap: () {
                            context.read<NavState>().setNav(last);
                          },
                          child: const Icon(Icons.arrow_back))
                      : null,
                  titleSpacing: 0,
                  title: Text(currentTitle),
                )
              : null,
          drawer: CustomDrawer(hide: true, prev: last),
          body: Row(
            children: [
              !Responsive.isSmall(context)
                  ? CustomDrawer(
                      hide: false,
                      prev: last,
                    )
                  : const FittedBox(),
              Expanded(
                child: Container(
                    padding: !Responsive.isSmall(context)
                        ? const EdgeInsets.all(25)
                        : const EdgeInsets.all(0),
                    color: secondaryColor,
                    child: Column(
                      children: [
                        !Responsive.isSmall(context)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentTitle,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            roles[user.role],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            user.name ?? user.school,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: secondaryTextColor,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: const EdgeInsets.only(left: 24),
                                        width: 60,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Image.asset(
                                          "assets/logo.png",
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : const FittedBox(),
                        !Responsive.isSmall(context)
                            ? const SizedBox(
                                height: 40,
                              )
                            : const FittedBox(),
                        BlocListener<NavState, int>(
                          listener: (blocContext, navState) {
                            if (pageController.hasClients && navState != -1) {
                              pageController.animateToPage(navState,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease);
                            }
                          },
                          child: Expanded(
                            child: PageView(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              controller: pageController,
                              children: const [
                                DashBoardScreen(),
                                AddClass(),
                                AddTeacher(),
                                AddStudent(),
                                AttendanceScreen(),
                                PaymentScreen(),
                                SupportScreen(),
                                ReportScreen(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
