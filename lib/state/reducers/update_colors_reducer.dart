import 'dart:developer';
import 'dart:ui';

import 'package:kolor_klash/state/actions/update_colors_action.dart';
import 'package:kolor_klash/state/subclasses/emptied_deck.dart';
import 'package:kolor_klash/state/subclasses/flushed_map.dart';
import 'package:kolor_klash/state/subclasses/tile_container_state.dart';
import 'package:kolor_klash/state/utilites/GameStateRules.dart';
import 'package:kolor_klash/widgets/tile_container.dart';

import '../../widgets/game_tile.dart';
import '../app_state.dart';

AppState updateColorsReducer(AppState previousState, UpdateColorsAction action) {
  // get the grid
  List<List<TileContainerReduxState>> grid = previousState.grid;
  // get the color and its column position
  Map<int, Color> newColor = action.colorMap;
  // get the updated deck
  List<GameTile?> deck = previousState.deck;
  // get the score
  int score = previousState.score;
  // get the turn count
  int turnCount = previousState.turnCount;

  // remove the missing tile
  deck[action.gameTileIndex] = null;

  // handle an emptied deck
  EmptiedDeck emptiedDeck = handleEmptyDeck(deck, grid.length, turnCount);

  // update turn count off of return
  turnCount = emptiedDeck.turnCount;

  // get the tile in question
  TileContainer tile = action.tile;

  // assign the updated color (protection provided by drag target willAccept)
  grid[tile.row][tile.column].colorMap[newColor.keys.first] = newColor.values.first;

  // unique set of tiles that can be flushed
  Set<TileContainerReduxState> flushables = GameStateRules.generateFlushableSet(grid, tile, newColor.values.first);

  // update deck off of return
  List<GameTile?> newDeck = emptiedDeck.deck;

  for(var tile in flushables) {
    FlushedMap flushedMap = flushColor(tile.colorMap, newColor.values.first);
    score += flushedMap.colorCount;
    tile.colorMap = flushedMap.colorMap;
  }

  AppState updatedAppState = AppState(gridSize: previousState.gridSize);
  updatedAppState.grid = grid;
  updatedAppState.deck = newDeck;
  updatedAppState.score = score;
  updatedAppState.turnCount = turnCount;
  updatedAppState.isGameOver = GameStateRules.isGameOver(grid, newDeck);
  updatedAppState.showRestartMenu = updatedAppState.isGameOver;
  if(updatedAppState.isGameOver) {
    log(updatedAppState.isGameOver.toString());
  }
  return updatedAppState;
}

/// empties a deck and increments turn count if empty
EmptiedDeck handleEmptyDeck(List<GameTile?> deck, int gridSize, int turnCount) {
  // check if the deck is "empty" ie all are null
  for(var entry in deck) {
    if(entry != null) {
      return EmptiedDeck(deck: deck, turnCount: turnCount);
    }
  }
  var newDeck = generateNewDeck(gridSize);
  turnCount = turnCount + 1;
  return EmptiedDeck(deck: newDeck, turnCount: turnCount);
}

/// method to remove the colors from a color map and return the number of times that color was in the map
FlushedMap flushColor(Map<int, Color> colorMap, Color color) {
  int colorCount = colorMap.length;
  colorMap.removeWhere((key, value) => value == color);
  colorCount -= colorMap.length;
  return FlushedMap(colorMap: colorMap, colorCount: colorCount);
}

/// method to generate a new deck
List<GameTile?> generateNewDeck(int gridSize) {
  List<GameTile?> deck = [];
  // populate the deck with excess
  for(var i  = 0; i < gridSize; i++) {
    deck.add(GameTile(max: gridSize, index: i, colorIndex: GameTile.generateColumnIndex(0, gridSize), color: GameTile.generateColor()));
  }
  return deck;
}
