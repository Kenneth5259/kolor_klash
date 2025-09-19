import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/tile_container.dart';
import '../models/game_deck.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<TilePlaced>(_onTilePlaced);
    on<GameReset>(_onGameReset);
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

    // Refill deck if empty
    final finalDeck = updatedDeck.refillIfEmpty();

    // Calculate score increase (could be based on various factors)
    final scoreIncrease = _calculateScoreIncrease(gameTile, updatedContainer);
    final newScore = currentState.score + scoreIncrease;

    // Check for game over conditions
    if (_isGameOver(updatedGrid, finalDeck)) {
      emit(GameOver(
        finalScore: newScore,
        finalGrid: updatedGrid,
      ));
      return;
    }

    // Emit updated game state
    emit(currentState.copyWith(
      grid: updatedGrid,
      deck: finalDeck,
      score: newScore,
    ));
  }

  void _onGameReset(GameReset event, Emitter<GameState> emit) {
    emit(GameInProgress.initial());
  }

  // Calculate score increase for placing a tile
  int _calculateScoreIncrease(gameTile, TileContainer updatedContainer) {
    // Simple scoring: 10 points per colored column placed
    int coloredColumns = 0;
    for (final color in gameTile.columnColors) {
      if (color != null) coloredColumns++;
    }

    // Bonus for filling a container completely
    int bonus = updatedContainer.isFull ? 50 : 0;

    return (coloredColumns * 10) + bonus;
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