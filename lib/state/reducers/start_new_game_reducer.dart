import 'package:kolor_klash/screens/game_board_screen.dart';
import 'package:kolor_klash/state/actions/start_new_game_action.dart';
import 'package:kolor_klash/state/app_state.dart';

AppState startNewGameReducer(AppState previousState, StartNewGameAction action) {
  previousState.difficulty = action.difficulty;
  previousState.gridSize = action.gridSize;
  previousState.activeScreen = const GameBoard();
  previousState.activePopupMenu = null;
  previousState.resetGameboard(action.gridSize, action.difficulty);
  previousState.resetStats();

  return previousState;
}
