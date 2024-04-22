import 'package:flutter/material.dart';
import 'package:score_card/data/my_sqlite.dart';
import 'package:score_card/main_screen.dart';

import 'teams.dart/team1.dart';
import 'teams.dart/team2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.insertPlayers(Team1().team1, dbHelper.team1Table);
  await dbHelper.insertPlayers(Team2().team2, dbHelper.team2Table);
  print("Players added successfully!");
  print(Team1().team1);
  print(Team2().team2);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
