import 'dart:async';

import 'package:flutter/material.dart';

class ZoneTimer extends ChangeNotifier {
  Timer? _timer;
  Timer? get timer => _timer;

  ZoneType _zoneType = ZoneType.pomodoro;
  ZoneType get zoneType => _zoneType;

  ZoneState _zoneState = ZoneState.stopped;
  ZoneState get zoneState => _zoneState;

  Duration _currentDuration = const Duration(minutes: 25);
  Duration get currentDuration => _currentDuration;

  ZoneSettings settings = ZoneSettings(
    pomodoroDuration: const Duration(seconds: 35),
    shortBreakDuration: const Duration(seconds: 30),
    longBreakDuration: const Duration(seconds: 40),
    autoTransition: true,
  );

  void startTimer() {
    _zoneState = ZoneState.running;
    _currentDuration = getZoneTypeDuration(_zoneType);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDuration -= const Duration(seconds: 1);

      if (_currentDuration.inSeconds <= 0) {
        stopTimer();

        if (settings.autoTransition) {
          switchZoneType(_zoneType.next);
          startTimer();
        }
      }

      notifyListeners();
    });
  }

  void switchZoneType(ZoneType state) {
    _zoneType = state;
    stopTimer();

    switch (_zoneType) {
      case ZoneType.pomodoro:
        _currentDuration = settings.pomodoroDuration;
        break;
      case ZoneType.shortBreak:
        _currentDuration = settings.shortBreakDuration;
        break;
      case ZoneType.longBreak:
        _currentDuration = settings.longBreakDuration;
        break;
    }

    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;

    _zoneState = ZoneState.stopped;
    _currentDuration = getZoneTypeDuration(_zoneType);

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;

    _zoneState = ZoneState.paused;

    notifyListeners();
  }

  Duration getZoneTypeDuration(ZoneType type) {
    switch (type) {
      case ZoneType.pomodoro:
        return settings.pomodoroDuration;
      case ZoneType.shortBreak:
        return settings.shortBreakDuration;
      case ZoneType.longBreak:
        return settings.longBreakDuration;
    }
  }

  void updateSettings(ZoneSettings newSettings) {
    settings = newSettings;

    _currentDuration = getZoneTypeDuration(_zoneType);

    notifyListeners();
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
