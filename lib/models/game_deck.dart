import 'game_tile.dart';
import 'game_difficulty.dart';

// Represents the game deck containing 3 game tiles
class GameDeck {
  final List<GameTile> tiles;

  const GameDeck({
    required this.tiles,
  });

  // Create a new deck with 3 random tiles based on difficulty
  factory GameDeck.newDeck([GameDifficulty? difficulty]) {
    final gameDifficulty = difficulty ?? GameDifficulty.normal;
    return GameDeck(
      tiles: [
        GameTile.random('D1', gameDifficulty),
        GameTile.random('D2', gameDifficulty),
        GameTile.random('D3', gameDifficulty),
      ],
    );
  }

  // Remove a tile from the deck by ID
  GameDeck removeTile(String tileId) {
    final newTiles = tiles.where((tile) => tile.id != tileId).toList();
    return GameDeck(tiles: newTiles);
  }

  // Get a tile by ID
  GameTile? getTile(String tileId) {
    try {
      return tiles.firstWhere((tile) => tile.id == tileId);
    } catch (e) {
      return null;
    }
  }

  // Check if deck is empty
  bool get isEmpty => tiles.isEmpty;

  // Check if deck has tiles
  bool get hasAnyTiles => tiles.isNotEmpty;

  // Get number of tiles remaining
  int get tileCount => tiles.length;

  // Refill deck if empty (returns new deck with 3 fresh tiles)
  GameDeck refillIfEmpty([GameDifficulty? difficulty]) {
    if (isEmpty) {
      return GameDeck.newDeck(difficulty);
    }
    return this;
  }

  GameDeck copyWith({
    List<GameTile>? tiles,
  }) {
    return GameDeck(
      tiles: tiles ?? List.from(this.tiles),
    );
  }
}