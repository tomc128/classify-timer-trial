import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_trial/duration_extensions.dart';
import 'package:timer_trial/zone/zone_clock_painter.dart';
import 'package:timer_trial/zone/zone_popup.dart';
import 'package:timer_trial/zone/zone_timer.dart';

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

    return Consumer<ZoneTimer>(
      builder: (context, timer, child) => Stack(
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: kHeaderPink,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(screenWidth / 2, 30),
                bottomRight: Radius.elliptical(screenWidth / 2, 30),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildZoneStateHeader(context, timer),
                buildClockWidget(context, timer),
                buildControlButtons(context, timer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildZoneStateHeader(BuildContext context, ZoneTimer timer) {
    var activeStyle = kSFTextStyle.copyWith(fontSize: 10, color: Colors.white);
    var inactiveStyle = kSFTextStyle.copyWith(fontSize: 10, color: kPurpleColor7);

    return Row(
      children: [
        GestureDetector(
          onTap: () => timer.switchZoneType(ZoneType.pomodoro),
          child: Text(
            'POMODORO',
            style: timer.zoneType == ZoneType.pomodoro ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => timer.switchZoneType(ZoneType.shortBreak),
          child: Text(
            'SHORT BREAK',
            style: timer.zoneType == ZoneType.shortBreak ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => timer.switchZoneType(ZoneType.longBreak),
          child: Text(
            'LONG BREAK',
            style: timer.zoneType == ZoneType.longBreak ? activeStyle : inactiveStyle,
          ),
        ),
      ],
    );
  }

  Widget buildClockWidget(BuildContext context, ZoneTimer timer) {
    return Container(
      width: 190,
      height: 190,
      margin: const EdgeInsets.fromLTRB(75, 20, 75, 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(190, 190),
            painter: ZoneClockPainter(
              progress: timer.progress,
            ),
          ),
          Text(
            timer.currentDuration.toFormattedString(),
            style: kGoogleSansTextStyle.copyWith(fontSize: 33, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildControlButtons(BuildContext context, ZoneTimer timer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: kPurpleColor2,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            iconSize: 20,
            onPressed: () => timer.stopTimer(),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF00FF), Color(0XFFFF2B79)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          width: 60,
          height: 60,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: Icon(timer.zoneState == ZoneState.running ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              iconSize: 32,
              onPressed: () {
                setState(() {
                  if (timer.zoneState == ZoneState.running) {
                    timer.pauseTimer();
                  } else {
                    timer.startTimer();
                  }
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        Material(
          color: kPurpleColor2,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit),
            color: Colors.white,
            iconSize: 20,
            onPressed: () async {
              var result = await showModalBottomSheet<ZoneSettings>(
                context: context,
                builder: (BuildContext context) => ZonePopup(settings: timer.settings),
                backgroundColor: Colors.transparent,
              );

              if (result != null) {
                timer.updateSettings(result);
                timer.stopTimer();
              }
            },
          ),
        ),
      ],
    );
  }
}
