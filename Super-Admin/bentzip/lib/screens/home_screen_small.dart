import 'package:bentzip/constants.dart';
import 'package:bentzip/screens/payment_screen.dart';
import 'package:bentzip/screens/report_screen.dart';
import 'package:bentzip/screens/support_screen.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:bentzip/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_school.dart';
import 'dashboard_screen.dart';

class HomeScreenSmall extends StatefulWidget {
  const HomeScreenSmall({Key? key}) : super(key: key);

  @override
  State<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends State<HomeScreenSmall> {
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
    return Builder(builder: (context) {
      return BlocBuilder<NavState, int>(builder: (blocContext, state) {
        if (pageController.hasClients) {
          pageController.jumpToPage(state);
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            titleSpacing: 0,
            title: Text(
              sideNavs[state].title,
            ),
          ),
          drawer: const CustomDrawer(hide: true),
          body: PageView(
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
        );
      });
    });
  }
}
