import 'package:flutter/material.dart';

class Responsive {
  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < 900;
}
