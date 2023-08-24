import 'package:flutter/material.dart';
import 'package:timer_trial/constants.dart';
import 'package:timer_trial/duration_extensions.dart';
import 'package:timer_trial/widgets/zone_switch.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        color: kPurpleColor3,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 125,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Auto-transition timer",
                  style: kGoogleSansTextStyle.copyWith(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 25),
                ZoneSwitch(
                  value: _settings.autoTransition,
                  onChanged: (value) => setState(() => _settings.autoTransition = value),
                ),
              ],
            ),
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
      ),
    );
  }

  Widget buildSlider(String label, Duration duration, void Function(Duration) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15), // Align text with slider
            child: Text(
              label,
              style: kGoogleSansTextStyle.copyWith(color: Colors.white, fontSize: 15),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SliderTheme(
                  data: const SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  ),
                  child: Slider(
                    value: duration.inSeconds.toDouble(),
                    min: 30,
                    max: 3600,
                    divisions: 119,
                    label: duration.toFormattedString(),
                    onChanged: (value) {
                      setState(() => onChanged(Duration(seconds: value.toInt())));
                    },
                    activeColor: kPurpleColor1,
                  ),
                ),
              ),
              Text(
                duration.toFormattedString(),
                style: kGoogleSansTextStyle.copyWith(color: kPurpleColor1, fontSize: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
