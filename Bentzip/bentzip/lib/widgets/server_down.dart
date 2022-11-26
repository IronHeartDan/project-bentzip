import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServerDown extends StatelessWidget {
  const ServerDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/asset_server_down.png"),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Server Down",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 24),
            ),
          ],
        ));
  }
}
