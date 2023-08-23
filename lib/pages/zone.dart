import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  ZoneType _zoneType = ZoneType.pomodoro;
  bool _isRunning = false;
  Duration _currentDuration = const Duration(minutes: 25);

  final ZoneSettings _settings = ZoneSettings(
    pomodoroDuration: const Duration(seconds: 25),
    shortBreakDuration: const Duration(seconds: 5),
    longBreakDuration: const Duration(seconds: 15),
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _currentDuration = _settings.pomodoroDuration;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildZoneStateHeader(context),

              // Clock
              buildClockWidget(context),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: kPurpleColor2,
                    child: IconButton.filled(
                      color: Colors.white,
                      onPressed: () {},
                      icon: const Icon(Icons.refresh),
                      iconSize: 17,
                    ),
                  ),
                  const SizedBox(width: 15),
                  CircleAvatar(
                    backgroundColor: kHeaderPink,
                    radius: 25,
                    child: IconButton.filled(
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _isRunning = !_isRunning);
                      },
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 35,
                    ),
                  ),
                  const SizedBox(width: 15),
                  CircleAvatar(
                    backgroundColor: kPurpleColor2,
                    child: IconButton.filled(
                      color: Colors.white,
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      iconSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentDuration.inSeconds > 0) {
          _currentDuration -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _timer = null;

          if (_settings.autoTransition) {
            switchZoneState(_zoneType.next);
          }
        }
      });
    });
  }

  void switchZoneState(ZoneType state) {
    setState(() {
      _zoneType = state;
      _isRunning = false;

      switch (_zoneType) {
        case ZoneType.pomodoro:
          _currentDuration = _settings.pomodoroDuration;
          break;
        case ZoneType.shortBreak:
          _currentDuration = _settings.shortBreakDuration;
          break;
        case ZoneType.longBreak:
          _currentDuration = _settings.longBreakDuration;
          break;
      }
    });
  }

  Widget buildZoneStateHeader(BuildContext context) {
    var activeStyle = kSFTextStyle.copyWith(fontSize: 10, color: Colors.white);
    var inactiveStyle = kSFTextStyle.copyWith(fontSize: 10, color: kPurpleColor7);

    return Row(
      children: [
        GestureDetector(
          onTap: () => switchZoneState(ZoneType.pomodoro),
          child: Text(
            'POMODORO',
            style: _zoneType == ZoneType.pomodoro ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => switchZoneState(ZoneType.shortBreak),
          child: Text(
            'SHORT BREAK',
            style: _zoneType == ZoneType.shortBreak ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => switchZoneState(ZoneType.longBreak),
          child: Text(
            'LONG BREAK',
            style: _zoneType == ZoneType.longBreak ? activeStyle : inactiveStyle,
          ),
        ),
      ],
    );
  }

  Widget buildClockWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(75, 20, 75, 20),
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: homePink, width: 5),
      ),
      child: Center(
        child: Text(
          formatDuration(_currentDuration),
          style: kGoogleSansTextStyle.copyWith(fontSize: 33, color: Colors.white),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

enum ZoneType {
  pomodoro,
  shortBreak,
  longBreak;

  ZoneType get next {
    switch (this) {
      case ZoneType.pomodoro:
        return ZoneType.shortBreak;
      case ZoneType.shortBreak:
        return ZoneType.pomodoro;
      case ZoneType.longBreak:
        return ZoneType.pomodoro;
    }
  }
}

enum ZoneState {
  running,
  paused,
  stopped,
}

class ZoneSettings {
  final Duration pomodoroDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final bool autoTransition;

  ZoneSettings({
    this.pomodoroDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.autoTransition = true,
  });
}
