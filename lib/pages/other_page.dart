import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_trial/duration_extensions.dart';
import 'package:timer_trial/zone/zone_timer.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ZoneTimer>(
        builder: (context, timer, _) => Text(
          'The timer is at: ${timer.currentDuration.toFormattedString()}',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
