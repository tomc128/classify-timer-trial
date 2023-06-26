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
    return Container(
      child: Center(
        child: Text(
          "<Zone Page>",
          style: kGoogleSansTextStyle.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
