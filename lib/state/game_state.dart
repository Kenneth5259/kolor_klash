import '../models/tile_container.dart';
import '../models/game_deck.dart';

abstract class GameState {}

// Initial state before game starts
class GameInitial extends GameState {}

// Game is actively being played
class GameInProgress extends GameState {
  final List<TileContainer> grid; // 9 tile containers (positions 1-9)
  final GameDeck deck; // Current deck with up to 3 tiles
  final int score;

  GameInProgress({
    required this.grid,
    required this.deck,
    required this.score,
  });

  // Create initial game state
  factory GameInProgress.initial() {
    return GameInProgress(
      grid: List.generate(9, (index) => TileContainer.empty(index + 1)),
      deck: GameDeck.newDeck(),
      score: 0,
    );
  }

  GameInProgress copyWith({
    List<TileContainer>? grid,
    GameDeck? deck,
    int? score,
  }) {
    return GameInProgress(
      grid: grid ?? this.grid,
      deck: deck ?? this.deck,
      score: score ?? this.score,
    );
  }
}

// Game over state
class GameOver extends GameState {
  final int finalScore;
  final List<TileContainer> finalGrid;

  GameOver({
    required this.finalScore,
    required this.finalGrid,
  });
}

// Error state for invalid moves
class GameError extends GameState {
  final String message;
  final GameInProgress previousState;

  GameError({
    required this.message,
    required this.previousState,
  });
}