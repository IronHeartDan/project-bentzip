import 'package:bentzip/models/school_student.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentProfile extends StatefulWidget {
  final SchoolStudent student;

  const StudentProfile({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: secondaryDarkColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${widget.student.name}/${widget.student.id}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Text(
                  "Student",
                  style: GoogleFonts.poppins(color: secondaryDarkColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  runSpacing: 20,
                  direction:  Responsive.isSmall(context) ? Axis.vertical : Axis.horizontal,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Text(
                            "${widget.student.schoolClass["standard"]} - ${widget.student.schoolClass["section"]}"),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.cake,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Text(DateFormat.yMMMd()
                            .format(DateTime.parse(widget.student.dob))
                            .toString()),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Text("${widget.student.contact[0]}"),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Text(widget.student.email),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Text(widget.student.address),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Guardian",
                  style: GoogleFonts.poppins(
                      color: primaryDarkColor, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var guardian = widget.student.guardian[index];
            return ListTile(
              title: Text(guardian["name"]),
              subtitle: Text("${guardian["contact"]}"),
            );
          }, childCount: widget.student.guardian.length),
        ),
      ],
    );
  }
}
