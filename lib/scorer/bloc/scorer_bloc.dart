import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'scorer_event.dart';
part 'scorer_state.dart';

class ScorerBloc {
  int _team1Runs = 0;
  bool _isTeam1Batting = true;
  int _team1Wickets = 0;
  int _team2Runs = 0;
  int _minimumOversForSwitch = 0;
  int _team2Wickets = 0;
  double _currentTeam2Over = 0.0;
  List<String> _history = [];
  Map<String, int> _team1PlayerScores = {};

  int get team1Runs => _team1Runs;
  int get minimumOversForSwitch => _minimumOversForSwitch;
  int get team1Wickets => _team1Wickets;
   int get team2Runs => _team2Runs;
  int get team2Wickets => _team2Wickets;
  double get currentTeam2Over => _currentTeam2Over;
  List<String> get history => _history;
  bool get isTeam1Batting => _isTeam1Batting;
  Map<String, int> get team1PlayerScores => _team1PlayerScores;

  ScorerBloc() {
    _loadData();
  }
  // It is to map it according to switch button
  void mapEventToState(ScorerEvent event, ) {
    if (event is UpdateScoreEvent && _isTeam1Batting) {
      _updateScore(event.button);
    } if (event is UpdateScoreEvent && !_isTeam1Batting) {
      _updateScoreForTeam2(event.button);
    } else if (event is UndoEvent) {
      _undo();
    }
  }
  // to get player scores
  int getPlayerScore(String playerName) {
    return _team1PlayerScores[playerName] ?? 0;
  }
  // to set minimu overs we are giving it. 
   setMinimumOversForSwitch(int value) {
    _minimumOversForSwitch = value;
  }
  // update the scores  
  void _updateScore(String button) {
  if (currentTeam2Over < _minimumOversForSwitch) {
    if (button == 'Undo') {
      _undo();
    } else if (button == 'WC' && _team1Wickets < 10) {
      _team1Wickets += 1;
      _history.add('Team 1- 1 wicket gone');
    } else {
      int runs = 0;
      if (button == 'NB' || button == 'WIDE') {
        runs = 1;
      } else {
        runs = int.tryParse(button) ?? 0;
      }

      if (runs >= 0 && runs <= 6) {
        _team1Runs += runs;
        _history.add('Team 1 - Runs added $runs');
        if (button != 'NB' && button != 'WIDE') {

          _currentTeam2Over += 0.1;
 
          if ((_currentTeam2Over - _currentTeam2Over.floor()) >= 0.6 && _currentTeam2Over < _minimumOversForSwitch) {
            _currentTeam2Over = _currentTeam2Over.ceil() + 0.0;
          }
        }
      }
    }
  }
  _saveData();
}


 void _updateScoreForTeam2(String button) {
  if (currentTeam2Over < _minimumOversForSwitch) {
    if (button == 'Undo') {
      _undo();
    } else if (button == 'WC' && _team2Wickets < 10) {
      _team2Wickets += 1;
      _history.add('Team 2- 1 wicket gone');
    } else {
      int runs = 0;
      if (button == 'NB' || button == 'WIDE') {
        runs = 1;
      } else {
        runs = int.tryParse(button) ?? 0;
      }

      if (runs >= 0 && runs <= 6) {
        _team2Runs += runs;
        _history.add('Team 2 Runs added $runs');
        if (button != 'NB' && button != 'WIDE') {
          _currentTeam2Over += 0.1;
         
          if ((_currentTeam2Over - _currentTeam2Over.floor()) >= 0.6 && _currentTeam2Over < _minimumOversForSwitch) {
            _currentTeam2Over = _currentTeam2Over.ceil() + 0.0;
          }
        }
      }
    }
  }
  _saveData();
}


  void toggleBattingTeam() {
    _isTeam1Batting = !_isTeam1Batting;
    if (!_isTeam1Batting) {
    _currentTeam2Over = 0.0; // Reset the over when switching to team 1
  }
  }

 void _undo() {
  if (_history.isNotEmpty) {
    String lastAction = _history.removeLast();
    if (lastAction.contains('Runs added')) {
      
      int runs = int.parse(lastAction.split(' ')[3]);
      _team1Runs -= runs;
    } else if (lastAction.contains('wicket gone')) {
      if (lastAction.startsWith('Team 1')) {
        _team1Wickets -= 1;
      } else {
        _team2Wickets -= 1;
      }
    }
    _saveData(); // Save data after undo
  }
}


  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('team1Runs', _team1Runs);
    await prefs.setInt('team1Wickets', _team1Wickets);
    await prefs.setDouble('currentTeam2Over', _currentTeam2Over);
    await prefs.setStringList('history', _history);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _team1Runs = prefs.getInt('team1Runs') ?? 0;
    _team1Wickets = prefs.getInt('team1Wickets') ?? 0;
    _currentTeam2Over = prefs.getDouble('currentTeam2Over') ?? 0.0;
    _history = prefs.getStringList('history') ?? [];
  }

  Future<List<String>> fetchDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Assuming you stored the history data as a List of Strings with a specific key
    List<String>? history = prefs.getStringList('history');
    return history ?? []; // Return an empty list if history is null
  }
}
