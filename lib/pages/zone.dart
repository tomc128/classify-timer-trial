import 'package:flutter/material.dart';

import '../constants.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: kHeaderPink,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(screenWidth / 2, 50),
              bottomRight: Radius.elliptical(screenWidth / 2, 50),
            ),
          ),
        ),
      ],
    );
  }
}
