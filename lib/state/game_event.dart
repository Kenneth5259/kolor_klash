import '../models/game_difficulty.dart';

abstract class GameEvent {}

// Event to start a new game
class GameStarted extends GameEvent {
  final GameDifficulty difficulty;

  GameStarted({this.difficulty = GameDifficulty.normal});
}

// Event to attempt placing a game tile on a tile container
class TilePlaced extends GameEvent {
  final String gameTileId;
  final int containerPosition;

  TilePlaced({
    required this.gameTileId,
    required this.containerPosition,
  });
}

// Event to reset the game
class GameReset extends GameEvent {
  final GameDifficulty? difficulty;

  GameReset({this.difficulty});
}

// Event to reroll the deck
class DeckRerolled extends GameEvent {}

// Event to complete color fade animation
class ColorFadeCompleted extends GameEvent {
  final Set<String> fadedColumns;

  ColorFadeCompleted({required this.fadedColumns});
}

// Event to load a saved game
class GameLoaded extends GameEvent {}

// Event to save the current game
class GameSaved extends GameEvent {}