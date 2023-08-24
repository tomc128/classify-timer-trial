import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_trial/constants.dart';
import 'package:timer_trial/pages/other_page.dart';
import 'package:timer_trial/pages/zone.dart';
import 'package:timer_trial/zone/zone_timer.dart';

void main(List<String> args) {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ZoneTimer(),
      child: const MaterialApp(
        home: ClassifyTrial(),
      ),
    ),
  );
}

class ClassifyTrial extends StatefulWidget {
  const ClassifyTrial({super.key});

  @override
  State<ClassifyTrial> createState() => _ClassifyTrialState();
}

class _ClassifyTrialState extends State<ClassifyTrial> {
  Widget _currentPage = const ZonePage();

  @override
  Widget build(BuildContext context) {
    return Consumer<ZoneTimer>(
      builder: (context, timer, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (timer.zoneState == ZoneState.running) {
              timer.pauseTimer();
            } else {
              timer.startTimer();
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF00FF), Color(0XFFFF2B79)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(timer.zoneState == ZoneState.running ? Icons.pause : Icons.play_arrow),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: kPurpleColor2,
          backgroundColor: kPurpleColor3,
          color: kPurpleColor2,
          onTap: (value) => {
            if (value == 0)
              {
                setState(() {
                  _currentPage = const ZonePage();
                })
              }
            else
              {
                setState(() {
                  _currentPage = const OtherPage();
                })
              }
          },
          items: [
            CurvedNavigationBarItem(
              child: Image.asset(
                'assets/icons/icons8_tomato_96px_3.png',
                height: 40,
                width: 40,
              ),
              label: "Zone",
              labelStyle: kGoogleSansTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.home_rounded,
                size: 40,
                color: Colors.white,
              ),
              label: "Other Page",
              labelStyle: kGoogleSansTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: kPurpleColor3,
        body: _currentPage,
      ),
    );
  }
}
