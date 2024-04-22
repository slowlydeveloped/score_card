import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalRunsTeam1 = 0;
  int totalWicketsTeam1 = 0;
  int ballsBowledTeam1 = 0;
  int totalRunsTeam2 = 0;
  int totalWicketsTeam2 = 0;
  int ballsBowledTeam2 = 0;
  int currentInning = 1; // 1 for Team 1's inning, 2 for Team 2's inning
  bool gameOver = false;

  final int maxOversPerInning = 5; // Fixed overs per inning

  List<String> scorer = [
    '0', '1', '2', '3', '4', '6', 'NB', 'WIDE', 'WC', 'Undo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Mania - Inning $currentInning'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Team $currentInning Batting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            cricketScorer(),
            SizedBox(height: 20),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  // Toggle expansion state
                  // You can add logic here to expand/collapse as needed
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('Team 1 Scorecard'),
                    );
                  },
                  body: teamScoreCard(1),
                  isExpanded: false, // Set initial expansion state
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('Team 2 Scorecard'),
                    );
                  },
                  body: teamScoreCard(2),
                  isExpanded: false, // Set initial expansion state
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cricketScorer() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: scorer.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (!gameOver) handleScoreTap(scorer[index]);
                },
                child: Card(
                  margin: EdgeInsets.all(9),
                  child: Center(
                    child: Text(
                      scorer[index],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Total Runs: ${currentInning == 1 ? totalRunsTeam1 : totalRunsTeam2}/'
              '${currentInning == 1 ? totalWicketsTeam1 : totalWicketsTeam2}',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          'Balls: ${ballsBowled(currentInning)}',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  String ballsBowled(int inning) {
    if (inning == 1) {
      return '$ballsBowledTeam1';
    } else {
      return '$ballsBowledTeam2';
    }
  }

  Widget teamScoreCard(int teamNumber) {
    int totalRuns = teamNumber == 1 ? totalRunsTeam1 : totalRunsTeam2;
    int totalWickets = teamNumber == 1 ? totalWicketsTeam1 : totalWicketsTeam2;
    int ballsBowled = teamNumber == 1 ? ballsBowledTeam1 : ballsBowledTeam2;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Runs: $totalRuns/$totalWickets', style: TextStyle(fontSize: 16)),
          Text('Balls Bowled: $ballsBowled', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void handleScoreTap(String type) {
    if (type == 'Undo') {
      undoAction();
      return;
    }

    int runs = 0;
    int wickets = 0;
    int balls = 1; // Default ball increment

    switch (type) {
      case '1':
      case '2':
      case '3':
      case '4':
      case '6':
        runs = int.parse(type);
        break;
      case 'WIDE':
        runs = 1; // Only update runs for wide ball
        balls = 0; // No increment in balls for wide ball
        break;
      case 'NB':
        runs = 1; // Extra run for no ball
        balls = 0; // No increment in balls for no ball
        break;
      case 'WC':
        wickets = 1;
        balls = 0; // Wicket, no ball bowled
        break;
      default:
        break;
    }

    setState(() {
      if (currentInning == 1) {
        totalRunsTeam1 += runs;
        totalWicketsTeam1 += wickets;
        ballsBowledTeam1 += balls;
        checkInningCompletion();
      } else {
        totalRunsTeam2 += runs;
        totalWicketsTeam2 += wickets;
        ballsBowledTeam2 += balls;
        checkInningCompletion();
      }
    });
  }

  void checkInningCompletion() {
    if (currentInning == 1) {
      if (ballsBowledTeam1 >= maxOversPerInning * 6 || totalWicketsTeam1 >= 10) {
        switchInning();
      }
    } else {
      if (ballsBowledTeam2 >= maxOversPerInning * 6 || totalWicketsTeam2 >= 10) {
        gameOver = true;
        showGameResult();
      }
    }
  }

  void switchInning() {
    setState(() {
      currentInning = 2; // Switch to Team 2's inning
      ballsBowledTeam1 = 0; // Reset balls for Team 1
      totalRunsTeam1 = 0;
      totalWicketsTeam1 = 0;
    });
  }

  void undoAction() {
    setState(() {
      if (currentInning == 1 && ballsBowledTeam1 > 0) {
        ballsBowledTeam1--;
      } else if (currentInning == 2 && ballsBowledTeam2 > 0) {
        ballsBowledTeam2--;
      }

      // Check if undoing a run
      if (currentInning == 1 && totalRunsTeam1 > 0) {
        totalRunsTeam1--;
      } else if (currentInning == 2 && totalRunsTeam2 > 0) {
        totalRunsTeam2--;
      }

      // Check if undoing a wicket
      if (currentInning == 1 && totalWicketsTeam1 > 0) {
        totalWicketsTeam1--;
      } else if (currentInning == 2 && totalWicketsTeam2 > 0) {
        totalWicketsTeam2--;
      }
    });
  }

  void showGameResult() {
    String winner = '';
    if (totalRunsTeam1 > totalRunsTeam2) {
      winner = 'Team 2';
    } else if (totalRunsTeam2 > totalRunsTeam1) {
      winner = 'Team 1';
    } else {
      winner = 'Match Drawn';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Match Over'),
          content: Text('Winner: $winner'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}