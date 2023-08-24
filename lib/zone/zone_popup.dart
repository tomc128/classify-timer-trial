import 'package:flutter/material.dart';
import 'package:timer_trial/duration_extensions.dart';
import 'package:timer_trial/zone/zone_timer.dart';

class ZonePopup extends StatefulWidget {
  final ZoneSettings settings;

  const ZonePopup({
    super.key,
    required this.settings,
  });

  @override
  State<ZonePopup> createState() => _ZonePopupState();
}

class _ZonePopupState extends State<ZonePopup> {
  late ZoneSettings _settings;

  @override
  void initState() {
    super.initState();

    _settings = ZoneSettings(
      pomodoroDuration: widget.settings.pomodoroDuration,
      shortBreakDuration: widget.settings.shortBreakDuration,
      longBreakDuration: widget.settings.longBreakDuration,
      autoTransition: widget.settings.autoTransition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Auto-transition timer"),
            Switch(
              value: widget.settings.autoTransition,
              onChanged: (value) => {
                setState(() {
                  _settings.autoTransition = value;
                })
              },
            ),
          ],
        ),
        buildSlider('Pomodoro', _settings.pomodoroDuration, (duration) {
          _settings.pomodoroDuration = duration;
        }),
        buildSlider('Short Break', _settings.shortBreakDuration, (duration) {
          _settings.shortBreakDuration = duration;
        }),
        buildSlider('Long Break', _settings.longBreakDuration, (duration) {
          _settings.longBreakDuration = duration;
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, _settings);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSlider(String label, Duration duration, void Function(Duration) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Slider(
                value: duration.inSeconds.toDouble(),
                min: 30,
                max: 3600,
                divisions: 119,
                label: duration.toFormattedString(),
                onChanged: (value) {
                  setState(() => onChanged(Duration(seconds: value.toInt())));
                },
              ),
            ],
          ),
        ),
        Text(duration.toFormattedString()),
      ],
    );
  }
}
