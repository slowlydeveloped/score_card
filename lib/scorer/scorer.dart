import 'package:flutter/material.dart';
import 'package:score_card/scorer/bloc/scorer_bloc.dart';
import '../viewer/viewer.dart';

class ScorerPage extends StatefulWidget {
  const ScorerPage({super.key});

  @override
  State<ScorerPage> createState() => _ScorerPageState();
}

class _ScorerPageState extends State<ScorerPage> {
  final ScorerBloc _scoreBloc = ScorerBloc();
  List<String> buttons = [ 
    '0',
    '1',
    '2',
    '3',
    '4',
    '6',
    'NB',
    'WIDE',
    'WC',
    'Undo',
  ];

  Future<void> _showMinimumOversDialog() async {
    int? minimumOvers = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int initialValue = _scoreBloc.minimumOversForSwitch;
        return AlertDialog(
          title: Text('Set Minimum Overs'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Minimum Overs'),
            onChanged: (value) {
              initialValue =
                  int.tryParse(value) ?? _scoreBloc.minimumOversForSwitch;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(initialValue);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    if (minimumOvers != null) {
      _scoreBloc.setMinimumOversForSwitch(minimumOvers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scorer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display Team 1 and Team 2 details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Display Team 1 details
                if (_scoreBloc.isTeam1Batting) ...[
                  Row(
                    children: [
                      Text("Team1"),
                      const SizedBox(width: 130),
                      Column(
                        children: [
                          Text("Runs"),
                          Text("${_scoreBloc.team1Runs}")
                        ],
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        children: [
                          Text("Wickets"),
                          Text("${_scoreBloc.team1Wickets}")
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                ],
                // Display Team 2 details
                if (!_scoreBloc.isTeam1Batting) ...[
                  Row(
                    children: [
                      Text("Team2"),
                      SizedBox(width: 130),
                      Column(
                        children: [
                          Text("Runs"),
                          Text("${_scoreBloc.team2Runs}")
                        ],
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Column(
                        children: [
                          Text("Wickets"),
                          Text("${_scoreBloc.team2Wickets}")
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ],
            ),
            Text(" Over ${_scoreBloc.currentTeam2Over.toStringAsFixed(1)}"),
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    shape: const CircleBorder(eccentricity: 1),
                    child: InkWell(
                      onTap: () async {
                        _scoreBloc
                            .mapEventToState(UpdateScoreEvent(buttons[index]));
                        setState(() {});
                      },
                      child: Center(
                        child: Text(
                          buttons[index],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    List<String> history =
                        await _scoreBloc.fetchDataFromSharedPrefs();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewerPage(history: history),
                      ),
                    );
                  },
                  child: Text('View History'),
                ),
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMinimumOversDialog();
                  },
                  child: Text('Set Minimum Overs'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_scoreBloc.currentTeam2Over >= _scoreBloc.minimumOversForSwitch) {
                  setState(() {
                    _scoreBloc.toggleBattingTeam();
                  });
                } else {
                  // Show a snackbar or toast indicating that switching is only allowed after 5 overs.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switching is only allowed after ${_scoreBloc.minimumOversForSwitch} overs.'),
                    ),
                  );
                }
              },
              child: Text('Switch'),
            ),
          ],
        ),
      ),
    );
  }
}
