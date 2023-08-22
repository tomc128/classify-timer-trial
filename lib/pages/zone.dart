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
          child: const Center(
            child: Image(
              image: AssetImage('assets/icons/icons8_tomato_96px_3.png'),
              width: 26,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 100, 16, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPurpleColor9,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'POMODORO',
                    style: kSFTextStyle.copyWith(fontSize: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SHORT BREAK',
                    style: kSFTextStyle.copyWith(fontSize: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'LONG BREAK',
                    style: kSFTextStyle.copyWith(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
