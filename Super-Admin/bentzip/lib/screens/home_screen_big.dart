import 'package:bentzip/constants.dart';
import 'package:bentzip/screens/add_school.dart';
import 'package:bentzip/screens/dashboard_screen.dart';
import 'package:bentzip/screens/payment_screen.dart';
import 'package:bentzip/screens/report_screen.dart';
import 'package:bentzip/screens/support_screen.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:bentzip/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBIg extends StatefulWidget {
  const HomeScreenBIg({Key? key}) : super(key: key);

  @override
  State<HomeScreenBIg> createState() => _HomeScreenBIgState();
}

class _HomeScreenBIgState extends State<HomeScreenBIg> {
  final pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(context.read<NavState>().state);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const CustomDrawer(hide: false),
          BlocBuilder<NavState, int>(builder: (blocContext, state) {
            if (pageController.hasClients) {
              pageController.jumpToPage(state);
            }
            return Expanded(
              child: Container(
                  padding: const EdgeInsets.all(25),
                  color: secondaryColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sideNavs[state].title,
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
                                    "Super Admin",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "System",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 24),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: secondaryDarkColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50))),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: const [
                            DashBoardScreen(),
                            AddSchool(),
                            PaymentScreen(),
                            SupportScreen(),
                            ReportScreen(),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          })
        ],
      ),
    );
  }
}
