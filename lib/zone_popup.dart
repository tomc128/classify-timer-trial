import 'package:flutter/material.dart';
import 'package:timer_trial/pages/zone.dart';

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

    _settings = widget.settings;
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
      ],
    );
  }

  Widget buildSlider(String label, Duration duration, void Function(Duration) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: duration.inSeconds.toDouble(),
          min: 0,
          max: 60,
          divisions: 60,
          label: duration.inSeconds.toString(),
          onChanged: (value) => {
            setState(() {
              onChanged(Duration(seconds: value.toInt()));
            })
          },
        ),
      ],
    );
  }
}
