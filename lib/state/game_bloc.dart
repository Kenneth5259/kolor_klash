import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/tile_container.dart';
import '../models/game_deck.dart';
import '../services/score_service.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<TilePlaced>(_onTilePlaced);
    on<GameReset>(_onGameReset);
    on<DeckRerolled>(_onDeckRerolled);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameInProgress.initial());
  }

  void _onTilePlaced(TilePlaced event, Emitter<GameState> emit) {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;

    // Find the game tile being placed
    final gameTile = currentState.deck.getTile(event.gameTileId);
    if (gameTile == null) {
      emit(GameError(
        message: 'Tile ${event.gameTileId} not found in deck',
        previousState: currentState,
      ));
      return;
    }

    // Find the target container
    final containerIndex = event.containerPosition - 1; // Convert 1-9 to 0-8
    if (containerIndex < 0 || containerIndex >= 9) {
      emit(GameError(
        message: 'Invalid container position: ${event.containerPosition}',
        previousState: currentState,
      ));
      return;
    }

    final targetContainer = currentState.grid[containerIndex];

    // Check if tile can be placed
    if (!targetContainer.canAcceptTile(gameTile)) {
      emit(GameError(
        message: 'Cannot place ${event.gameTileId} on position ${event.containerPosition}',
        previousState: currentState,
      ));
      return;
    }

    // Place the tile
    final updatedContainer = targetContainer.placeTile(gameTile);
    final updatedGrid = List<TileContainer>.from(currentState.grid);
    updatedGrid[containerIndex] = updatedContainer;

    // Remove tile from deck
    final updatedDeck = currentState.deck.removeTile(event.gameTileId);

    // Refill deck if empty and track refills
    final finalDeck = updatedDeck.refillIfEmpty();
    final wasRefilled = updatedDeck.tiles.isEmpty && finalDeck.tiles.isNotEmpty;
    final newRefillCount = wasRefilled ? currentState.deckRefillCount + 1 : currentState.deckRefillCount;

    // Award reroll every 10 refills
    final newRerolls = wasRefilled && newRefillCount % 10 == 0
        ? currentState.rerollsAvailable + 1
        : currentState.rerollsAvailable;

    // Check for color matches and process them
    final matchResult = _processColorMatches(updatedGrid);
    final processedGrid = matchResult['grid'] as List<TileContainer>;
    final scoreIncrease = matchResult['score'] as int;
    final newScore = currentState.score + scoreIncrease;

    // Check for game over conditions
    if (_isGameOver(processedGrid, finalDeck)) {
      // Save the score when game ends
      ScoreService.saveScore(newScore);

      emit(GameOver(
        finalScore: newScore,
        finalGrid: processedGrid,
      ));
      return;
    }

    // Emit updated game state
    emit(currentState.copyWith(
      grid: processedGrid,
      deck: finalDeck,
      score: newScore,
      rerollsAvailable: newRerolls,
      deckRefillCount: newRefillCount,
    ));
  }

  void _onGameReset(GameReset event, Emitter<GameState> emit) {
    emit(GameInProgress.initial());
  }

  void _onDeckRerolled(DeckRerolled event, Emitter<GameState> emit) {
    print('DeckRerolled event received'); // Debug
    if (state is! GameInProgress) {
      print('State is not GameInProgress: ${state.runtimeType}'); // Debug
      return;
    }

    final currentState = state as GameInProgress;
    print('Current rerolls: ${currentState.rerollsAvailable}'); // Debug

    // Check if player has rerolls available
    if (currentState.rerollsAvailable <= 0) {
      print('No rerolls available'); // Debug
      emit(GameError(
        message: 'No rerolls available',
        previousState: currentState,
      ));
      return;
    }

    // Create new deck and decrease reroll count
    final newDeck = GameDeck.newDeck();
    final newRerolls = currentState.rerollsAvailable - 1;
    print('Creating new deck, rerolls: $newRerolls'); // Debug

    // Emit updated state with new deck and decreased rerolls
    emit(currentState.copyWith(
      deck: newDeck,
      rerollsAvailable: newRerolls,
    ));
  }

  // Process color matches and return updated grid and score
  Map<String, dynamic> _processColorMatches(List<TileContainer> grid) {
    final gridToProcess = List<TileContainer>.from(grid);
    int totalScore = 0;

    // Check for matches and process them
    final matchedColumns = _findColorMatches(gridToProcess);

    if (matchedColumns.isNotEmpty) {
      // Calculate score based on number of columns flushed
      totalScore = matchedColumns.length * 10; // 10 points per flushed column

      // Remove matched colors (reset to transparent)
      final processedGrid = _removeMatchedColors(gridToProcess, matchedColumns);

      return {
        'grid': processedGrid,
        'score': totalScore,
      };
    }

    return {
      'grid': gridToProcess,
      'score': 0,
    };
  }

  // Find all color matches in the grid
  Set<String> _findColorMatches(List<TileContainer> grid) {
    final matchedColumns = <String>{};

    // Check each container for single tile matches (all 3 columns same color)
    for (int i = 0; i < 9; i++) {
      final container = grid[i];
      final singleTileMatches = _findSingleTileMatches(container, i);
      matchedColumns.addAll(singleTileMatches);
    }

    // Check for line matches (vertical, horizontal, diagonal)
    final lineMatches = _findLineMatches(grid);
    matchedColumns.addAll(lineMatches);

    return matchedColumns;
  }

  // Find matches within a single tile container (all 3 columns same color)
  Set<String> _findSingleTileMatches(TileContainer container, int containerIndex) {
    final matchedColumns = <String>{};
    final colors = container.columnColors;

    // Check if all 3 columns have the same non-null color
    if (colors[0] != null && colors[1] != null && colors[2] != null) {
      if (_colorsEqual(colors[0]!, colors[1]!) && _colorsEqual(colors[1]!, colors[2]!)) {
        // All 3 columns match - add all to matched set
        matchedColumns.add('$containerIndex-0');
        matchedColumns.add('$containerIndex-1');
        matchedColumns.add('$containerIndex-2');
      }
    }

    return matchedColumns;
  }

  Set<String> _findLineMatches(List<TileContainer> grid) {
    final matchedColumns = <String>{};

    final lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Vertical
      [0, 4, 8], [2, 4, 6],            // Diagonal
    ];

    for (final line in lines) {
      // Collect all non-null colors in each tile
      final tileColors = line.map((i) => grid[i].columnColors.whereType<Color>().toSet()).toList();
      // Find intersection (colors present in all three tiles)
      final commonColors = tileColors.reduce((a, b) => a.intersection(b));
      for (final color in commonColors) {
        for (final tileIndex in line) {
          for (int col = 0; col < 3; col++) {
            if (grid[tileIndex].columnColors[col] != null &&
                _colorsEqual(grid[tileIndex].columnColors[col]!, color)) {
              matchedColumns.add('$tileIndex-$col');
            }
          }
        }
      }
    }

    return matchedColumns;
  }



  // Helper method to compare colors reliably
  bool _colorsEqual(Color color1, Color color2) {
    return color1 == color2;
  }

  // Remove matched colors from the grid
  List<TileContainer> _removeMatchedColors(List<TileContainer> grid, Set<String> matchedColumns) {
    final updatedGrid = <TileContainer>[];

    for (int containerIndex = 0; containerIndex < 9; containerIndex++) {
      final container = grid[containerIndex];
      final newColors = List<Color?>.from(container.columnColors);

      // Check each column in this container
      for (int col = 0; col < 3; col++) {
        final columnKey = '$containerIndex-$col';
        if (matchedColumns.contains(columnKey)) {
          newColors[col] = null; // Reset to transparent
        }
      }

      updatedGrid.add(container.copyWith(columnColors: newColors));
    }

    return updatedGrid;
  }

  // Check if game is over (no valid moves possible)
  bool _isGameOver(List<TileContainer> grid, GameDeck deck) {
    // Game is over if no deck tiles can be placed on any grid container
    for (final gameTile in deck.tiles) {
      for (final container in grid) {
        if (container.canAcceptTile(gameTile)) {
          return false; // Found a valid move
        }
      }
    }
    return true; // No valid moves found
  }
}