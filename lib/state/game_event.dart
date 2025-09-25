abstract class GameEvent {}

// Event to start a new game
class GameStarted extends GameEvent {}

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
class GameReset extends GameEvent {}

// Event to reroll the deck
class DeckRerolled extends GameEvent {}

// Event to complete color fade animation
class ColorFadeCompleted extends GameEvent {
  final Set<String> fadedColumns;

  ColorFadeCompleted({required this.fadedColumns});
}