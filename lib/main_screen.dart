import 'package:flutter/material.dart';
import 'package:score_card/common_things/button.dart';
import 'package:score_card/scorer/scorer_login.dart';
import 'package:score_card/viewer/viewer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton(
                title: "Scorer",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScorerLoginPage()));
                }),
            const SizedBox(height: 10),
            CommonButton(
                title: "Viewer",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewerPage(history: [],)));
                })
          ],
        ),
      ),
    );
  }
}
