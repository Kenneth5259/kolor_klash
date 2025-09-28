import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_difficulty.dart';
import '../models/tile_container.dart';
import '../models/game_deck.dart';
import '../models/game_tile.dart';
import '../state/game_state.dart';

class GamePersistenceService {
  static const String _gameStateKey = 'saved_game_state';
  static const String _hasActiveGameKey = 'has_active_game';

  /// Save the current game state to local storage
  static Future<void> saveGameState(GameInProgress gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = _gameStateToJson(gameState);

      await prefs.setString(_gameStateKey, jsonEncode(gameStateJson));
      await prefs.setBool(_hasActiveGameKey, true);
    } catch (e) {
      // Log error but don't throw to avoid breaking game flow
      print('Error saving game state: $e');
    }
  }

  /// Load a saved game state from local storage
  static Future<GameInProgress?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasActiveGame = prefs.getBool(_hasActiveGameKey) ?? false;

      if (!hasActiveGame) {
        return null;
      }

      final gameStateString = prefs.getString(_gameStateKey);
      if (gameStateString == null) {
        return null;
      }

      final gameStateJson = jsonDecode(gameStateString) as Map<String, dynamic>;
      return _gameStateFromJson(gameStateJson);
    } catch (e) {
      print('Error loading game state: $e');
      // Clear corrupted save data
      await clearSavedGame();
      return null;
    }
  }

  /// Check if there's a saved game available
  static Future<bool> hasSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasActiveGameKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Clear the saved game state (called when game ends or is completed)
  static Future<void> clearSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_gameStateKey);
      await prefs.setBool(_hasActiveGameKey, false);
    } catch (e) {
      print('Error clearing saved game: $e');
    }
  }

  /// Convert GameInProgress to JSON
  static Map<String, dynamic> _gameStateToJson(GameInProgress gameState) {
    return {
      'grid': gameState.grid.map((container) => _tileContainerToJson(container)).toList(),
      'deck': _gameDeckToJson(gameState.deck),
      'score': gameState.score,
      'rerollsAvailable': gameState.rerollsAvailable,
      'deckRefillCount': gameState.deckRefillCount,
      'difficulty': gameState.difficulty.name,
    };
  }

  /// Convert JSON to GameInProgress
  static GameInProgress _gameStateFromJson(Map<String, dynamic> json) {
    final gridJson = json['grid'] as List<dynamic>;
    final grid = gridJson.map((containerJson) =>
        _tileContainerFromJson(containerJson as Map<String, dynamic>)).toList();

    final deck = _gameDeckFromJson(json['deck'] as Map<String, dynamic>);
    final difficulty = GameDifficulty.fromString(json['difficulty'] as String);

    return GameInProgress(
      grid: grid,
      deck: deck,
      score: json['score'] as int,
      rerollsAvailable: json['rerollsAvailable'] as int,
      deckRefillCount: json['deckRefillCount'] as int,
      difficulty: difficulty,
    );
  }

  /// Convert TileContainer to JSON
  static Map<String, dynamic> _tileContainerToJson(TileContainer container) {
    return {
      'position': container.position,
      'columnColors': container.columnColors.map((color) =>
          color?.value).toList(),
    };
  }

  /// Convert JSON to TileContainer
  static TileContainer _tileContainerFromJson(Map<String, dynamic> json) {
    final colorValues = json['columnColors'] as List<dynamic>;
    final columnColors = colorValues.map((colorValue) =>
        colorValue != null ? Color(colorValue as int) : null).toList();

    return TileContainer(
      position: json['position'] as int,
      columnColors: columnColors,
    );
  }

  /// Convert GameDeck to JSON
  static Map<String, dynamic> _gameDeckToJson(GameDeck deck) {
    return {
      'tiles': deck.tiles.map((tile) => _gameTileToJson(tile)).toList(),
    };
  }

  /// Convert JSON to GameDeck
  static GameDeck _gameDeckFromJson(Map<String, dynamic> json) {
    final tilesJson = json['tiles'] as List<dynamic>;
    final tiles = tilesJson.map((tileJson) =>
        _gameTileFromJson(tileJson as Map<String, dynamic>)).toList();

    return GameDeck(tiles: tiles);
  }

  /// Convert GameTile to JSON
  static Map<String, dynamic> _gameTileToJson(GameTile tile) {
    return {
      'id': tile.id,
      'columnColors': tile.columnColors.map((color) =>
          color?.value).toList(),
    };
  }

  /// Convert JSON to GameTile
  static GameTile _gameTileFromJson(Map<String, dynamic> json) {
    final colorValues = json['columnColors'] as List<dynamic>;
    final columnColors = colorValues.map((colorValue) =>
        colorValue != null ? Color(colorValue as int) : null).toList();

    return GameTile(
      id: json['id'] as String,
      columnColors: columnColors,
    );
  }
}