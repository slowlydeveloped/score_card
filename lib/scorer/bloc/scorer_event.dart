part of 'scorer_bloc.dart';

@immutable
sealed class ScorerEvent {}

class UpdateScoreEvent extends ScorerEvent {
  final String button;

  UpdateScoreEvent(this.button);
}

class UpdateScoreForTeam2Event extends ScorerEvent {
  final String button;

  UpdateScoreForTeam2Event(this.button);
}

class UndoEvent extends ScorerEvent {}
