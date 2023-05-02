import 'package:bentzip/utils/responsive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/constants.dart';
import '../utils/repository.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Repository repository;

  @override
  void initState() {
    repository = RepositoryProvider.of<Repository>(context);
    super.initState();
  }

  Future getAttendance() async {
    try {
      var res = await repository.fetchAttendance();
      return res;
    } on DioError catch (e) {
      showSnack(e.message, true);
    }
  }

  void showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error ? Colors.red : Colors.green,
      content: Text(msg),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAttendance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Responsive.isSmall(context)
                      ? null
                      : const BorderRadius.all(Radius.circular(20))),
              child: ListView.builder(
                  itemCount: (data as List).length,
                  itemBuilder: (context, index) {
                    var info = data[index];
                    return ListTile(
                      title: Text("Standard : ${info['standard']}"),
                      trailing: Text(
                        "${info['percentage']}%",
                        style: TextStyle(
                            color: info['percentage'] > 60
                                ? Colors.green
                                : Colors.redAccent),
                      ),
                      onTap: () {},
                    );
                  }),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        });
  }
}
