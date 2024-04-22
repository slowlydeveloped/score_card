part of 'scorer_bloc.dart';

@immutable
sealed class ScorerState {}

final class ScorerInitial extends ScorerState {
   final List<int> team1RunsList;
  final int team1Wickets;
  final List<int> team2RunsList;

  ScorerInitial({ required this.team1RunsList, required this.team1Wickets, required this.team2RunsList});
}


