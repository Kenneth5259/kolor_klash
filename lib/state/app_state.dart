import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kolor_klash/state/subclasses/enums.dart';
import 'package:kolor_klash/state/subclasses/tile_container_state.dart';

import '../screens/main_menu_screen.dart';
import '../widgets/game_tile.dart';
import '../widgets/tile_container.dart';

class AppState {
  int gridSize;
  Difficulty difficulty = Difficulty.easy;
  int turnCount = 0;
  int score = 0;
  double gameTileHeight = 0;
  double gameTileWidth = 0;
  bool initialized = false;
  bool isGameOver = false;
  bool showRestartMenu = false;
  bool showSettingsMenu = false;
  late List<List<TileContainerReduxState>> grid;

  Widget? activeScreen;
  late List<GameTile?> deck;

  AppState({required this.gridSize}) {
    activeScreen = activeScreen ?? const MainMenuScreen();
    resetGameboard(gridSize);
  }

  resetStats() {
    turnCount = 0;
    score = 0;
  }

  resetGameboard(int gridSize) {
    grid = [];
    deck = [];
    for(var i = 0; i < gridSize; i++) {
      List<TileContainerReduxState> row = [];
      for(var j = 0; j < gridSize; j++) {
        //GlobalKey<TileContainerState> tileContainerKey = GlobalKey();
        row.add(TileContainerReduxState(container: TileContainer(size: gridSize, row: i, column: j)));
      }
      deck.add(GameTile(max: gridSize, index: i, color: GameTile.generateColor(), colorIndex: GameTile.generateColumnIndex(0, gridSize),));
      grid.add(row);
    }
  }

  Map toJson() {
    return {
      // basic types
      'gridSize': gridSize,
      'difficulty': difficulty.toString(),
      'turnCount': turnCount,
      'score': score,
      'gameTileHeight': gameTileHeight,
      'gameTileWidth': gameTileWidth,
      'initialized': true,
      'isGameOver': false,
      'showRestartMenu': false,
      'showSettingsMenu': false,

      // lists
      'deck': getDeckJson(),
      'grid': getGridJSON()
    };
  }

  List getDeckJson() {
    List deckJson = [];
    for (GameTile? tile in deck) {
      deckJson.add(tile != null ? tile.toJson() : 'null');
    }
    return deckJson;
  }

  List getGridJSON() {
    List gridJson = [];
    for(List<TileContainerReduxState> row in grid) {
      List rowJson = [];
      for(TileContainerReduxState tile in row) {
        rowJson.add(tile.toJson());
      }
      gridJson.add(rowJson);
    }
    return gridJson;
  }

  static AppState loadFromJson(String json) {
    Map values = jsonDecode(json);
    AppState loadedState = AppState(gridSize: values["gridSize"]);
    loadedState.difficulty = stringToDifficulty(values["difficulty"]);
    loadedState.turnCount = int.parse(values["turnCount"]);
    loadedState.score = int.parse(values["score"]);
    loadedState.gameTileWidth = double.parse(values["gameTileWidth"]);
    loadedState.gameTileHeight = double.parse(values["gameTileHeight"]);
    loadedState.initialized = true;
    loadedState.isGameOver = false;
    loadedState.showSettingsMenu = false;
    loadedState.showRestartMenu = false;

    // TODO: Load Deck from File

    // TODO: Load Grid from File
    return loadedState;
  }
}
