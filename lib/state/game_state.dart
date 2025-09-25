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
  final int rerollsAvailable; // Number of rerolls the player has
  final int deckRefillCount; // Track how many times deck has been refilled

  GameInProgress({
    required this.grid,
    required this.deck,
    required this.score,
    required this.rerollsAvailable,
    required this.deckRefillCount,
  });

  // Create initial game state
  factory GameInProgress.initial() {
    return GameInProgress(
      grid: List.generate(9, (index) => TileContainer.empty(index + 1)),
      deck: GameDeck.newDeck(),
      score: 0,
      rerollsAvailable: 2, // Start with 2 rerolls
      deckRefillCount: 0,
    );
  }

  GameInProgress copyWith({
    List<TileContainer>? grid,
    GameDeck? deck,
    int? score,
    int? rerollsAvailable,
    int? deckRefillCount,
  }) {
    return GameInProgress(
      grid: grid ?? this.grid,
      deck: deck ?? this.deck,
      score: score ?? this.score,
      rerollsAvailable: rerollsAvailable ?? this.rerollsAvailable,
      deckRefillCount: deckRefillCount ?? this.deckRefillCount,
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

// Game state when colors are fading out
class GameFadingColors extends GameState {
  final List<TileContainer> grid;
  final GameDeck deck;
  final int score;
  final int rerollsAvailable;
  final int deckRefillCount;
  final Set<String> fadingColumns; // Format: 'containerIndex-columnIndex'

  GameFadingColors({
    required this.grid,
    required this.deck,
    required this.score,
    required this.rerollsAvailable,
    required this.deckRefillCount,
    required this.fadingColumns,
  });

  // Convert back to GameInProgress after animation
  GameInProgress toGameInProgress(List<TileContainer> newGrid) {
    return GameInProgress(
      grid: newGrid,
      deck: deck,
      score: score,
      rerollsAvailable: rerollsAvailable,
      deckRefillCount: deckRefillCount,
    );
  }
}