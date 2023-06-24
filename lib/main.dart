import 'package:flutter/material.dart';
import 'package:timer_trial/constants.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: ClassifyTrial(),
  ));
}

class ClassifyTrial extends StatefulWidget {
  const ClassifyTrial({super.key});

  @override
  State<ClassifyTrial> createState() => _ClassifyTrialState();
}

class _ClassifyTrialState extends State<ClassifyTrial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Classify Trial',
          style: kGoogleSansTextStyle.copyWith(fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: kPurpleColor2,
      ),
      backgroundColor: kPurpleColor3,
      body: Container(
        child: Center(
          child: Text(
            "<Add UI Here>",
            style: kGoogleSansTextStyle,
          ),
        ),
      ),
    );
  }
}
