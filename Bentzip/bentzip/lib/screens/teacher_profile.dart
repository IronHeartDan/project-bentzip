import 'package:bentzip/models/school_teacher.dart';
import 'package:bentzip/utils/constants.dart';
import 'package:bentzip/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TeacherProfile extends StatefulWidget {
  final SchoolTeacher teacher;

  const TeacherProfile({Key? key, required this.teacher}) : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
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
                  "${widget.teacher.name}/${widget.teacher.id}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Text(
                  "Teacher",
                  style: GoogleFonts.poppins(color: secondaryDarkColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  runSpacing: 20,
                  direction: Responsive.isSmall(context)
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        Text(widget.teacher.education[0]["qualification"]),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            .format(DateTime.parse(widget.teacher.dob))
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        Text("${widget.teacher.contact[0]}"),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        Text(widget.teacher.email),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        Flexible(
                          child: Text(widget.teacher.address,
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.visible),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Education",
                  style: GoogleFonts.poppins(
                      color: primaryDarkColor, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var education = widget.teacher.education[index];
            return ListTile(
              title: Text(education["institution"]),
              subtitle: Text(
                  "${DateTime.parse(education["start"]).year} - ${DateTime.parse(education["end"]).year}"),
            );
          }, childCount: widget.teacher.education.length),
        ),
      ],
    );
  }
}
