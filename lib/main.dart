import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:kolor_klash/screens/game_board.dart';
import 'package:kolor_klash/state/app_reducer.dart';
import 'package:kolor_klash/state/app_state.dart';
import 'package:redux/redux.dart';

void main() {

  final store = Store<AppState>(appReducer, initialState: AppState(gridSize: 3));

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          home: const Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: GameBoard()
            ),
          )
        ),
    );
  }
}

