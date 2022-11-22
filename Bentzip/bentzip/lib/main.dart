import 'package:bentzip/screens/splash_screen.dart';
import 'package:bentzip/states/actions_state.dart';
import 'package:bentzip/states/connection_state.dart';
import 'package:bentzip/states/nav_state.dart';
import 'package:bentzip/states/nav_title_state.dart';
import 'package:bentzip/states/teachers_state.dart';
import 'package:bentzip/states/user_state.dart';
import 'package:bentzip/utils/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConnectionState>(
            create: (context) => AppConnectionState()),
        BlocProvider<NavState>(create: (context) => NavState(0)),
        BlocProvider<NavTitleState>(create: (context) => NavTitleState("")),
        BlocProvider<ActionsState>(create: (context) => ActionsState(null)),
        BlocProvider<UserState>(create: (context) => UserState(null)),
        BlocProvider<TeachersState>(create: (context) => TeachersState(null)),
      ],
      child: RepositoryProvider<Repository>(
        create: (BuildContext context) => Repository(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bentzip',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
