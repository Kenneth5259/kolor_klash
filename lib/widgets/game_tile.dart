import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kolor_klash/state/actions/update_deck_action.dart';
import 'package:kolor_klash/widgets/flex_column.dart';
import 'package:redux/redux.dart';
import 'dart:math';

import '../state/app_state.dart';

class GameTile extends StatefulWidget {
  final int max;
  final int index;

  const GameTile({super.key, required this.max, required this.index});

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  final colors = <Color>[Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];

  final random = Random();

  final min = 0;
  int colorIndex = 0;

  Color? color;

  @override
  Widget build(BuildContext context) {

    if(color == null) {
      generateColor();
    }

    Widget tile = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black)
        ),
        child: Row(
          children: generateColumns(),
        ),
      ),
    );

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Draggable<Map<int, Color>>(
          data: {colorIndex: color!},
          feedback: SizedBox(
              width: 75,
              height: 75,
              child: tile
          ),
          childWhenDragging: null,
          onDragCompleted: onDragComplete,
          child: tile,
        );
      }
    );
  }

  List<FlexColumn> generateColumns() {
    List<FlexColumn> columns = [];

    for (var i = 0; i < widget.max; i++) {
      columns.add(FlexColumn(color: i == colorIndex ? color : null));
    }

    return columns;
  }

  void generateColor() {
    // shuffle the available colors
    var shuffledColors = [...colors];
    shuffledColors.shuffle();

    setState(() {
      // set the color column
      colorIndex = generateColumnIndex();
      // set the color for the column
      color = shuffledColors[0];
    });


  }

  int generateColumnIndex() {
    return min + random.nextInt(widget.max - min);
  }

  void onDragComplete() {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(UpdateDeckAction(store.state.deck, widget));
    color = null;
  }
}
