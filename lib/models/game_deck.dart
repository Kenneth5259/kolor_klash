import 'game_tile.dart';

// Represents the game deck containing 3 game tiles
class GameDeck {
  final List<GameTile> tiles;

  const GameDeck({
    required this.tiles,
  });

  // Create a new deck with 3 random tiles
  factory GameDeck.newDeck() {
    return GameDeck(
      tiles: [
        GameTile.random('D1'),
        GameTile.random('D2'),
        GameTile.random('D3'),
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
  GameDeck refillIfEmpty() {
    if (isEmpty) {
      return GameDeck.newDeck();
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