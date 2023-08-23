import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_trial/zone_popup.dart';

import '../constants.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  ZoneType _zoneType = ZoneType.pomodoro;
  ZoneState _zoneState = ZoneState.stopped;
  Duration _currentDuration = const Duration(minutes: 25);

  ZoneSettings _settings = ZoneSettings(
    pomodoroDuration: const Duration(seconds: 35),
    shortBreakDuration: const Duration(seconds: 30),
    longBreakDuration: const Duration(seconds: 40),
    autoTransition: true,
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
              buildClockWidget(context),
              buildControlButtons(context),
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
            switchZoneType(_zoneType.next);
            startTimer();
          }
        }
      });
    });

    setState(() => _zoneState = ZoneState.running);
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;

    setState(() => _zoneState = ZoneState.paused);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _zoneState = ZoneState.stopped;
      _currentDuration = getZoneTypeMaxDuration(_zoneType);
    });
  }

  void switchZoneType(ZoneType state) {
    setState(() {
      _zoneType = state;
      _zoneState = ZoneState.stopped;

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
          onTap: () => switchZoneType(ZoneType.pomodoro),
          child: Text(
            'POMODORO',
            style: _zoneType == ZoneType.pomodoro ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => switchZoneType(ZoneType.shortBreak),
          child: Text(
            'SHORT BREAK',
            style: _zoneType == ZoneType.shortBreak ? activeStyle : inactiveStyle,
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => switchZoneType(ZoneType.longBreak),
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

  Widget buildControlButtons(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Ink(
            decoration: ShapeDecoration(
              color: kPurpleColor2,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  stopTimer();
                });
              },
            ),
          ),
          const SizedBox(width: 15),
          Ink(
            decoration: const ShapeDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF00FF),
                  Color(0XFFFF2B79),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(_zoneState == ZoneState.running ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  switch (_zoneState) {
                    case ZoneState.running:
                      pauseTimer();
                      break;
                    case ZoneState.paused:
                    case ZoneState.stopped:
                      startTimer();
                      break;
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 15),
          Ink(
            decoration: ShapeDecoration(
              color: kPurpleColor2,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () async {
                var result = await showModalBottomSheet<ZoneSettings>(
                  context: context,
                  builder: (BuildContext context) => ZonePopup(settings: _settings),
                );

                if (result != null) {
                  setState(() {
                    _settings = result;
                    switchZoneType(_zoneType);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration getZoneTypeMaxDuration(ZoneType type) {
    switch (type) {
      case ZoneType.pomodoro:
        return _settings.pomodoroDuration;
      case ZoneType.shortBreak:
        return _settings.shortBreakDuration;
      case ZoneType.longBreak:
        return _settings.longBreakDuration;
    }
  }
}

enum ZoneType {
  pomodoro,
  shortBreak,
  longBreak;

  ZoneType get next {
    // The sequence should probably be, pomodoro -> (short break -> pomodoro) [some amount of times] -> long break -> repeat
    // however, the brief simply says pomodoro -> short break -> long break -> repeat
    switch (this) {
      case ZoneType.pomodoro:
        return ZoneType.shortBreak;
      case ZoneType.shortBreak:
        return ZoneType.longBreak;
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
  Duration pomodoroDuration;
  Duration shortBreakDuration;
  Duration longBreakDuration;
  bool autoTransition;

  ZoneSettings({
    this.pomodoroDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.autoTransition = true,
  });
}
