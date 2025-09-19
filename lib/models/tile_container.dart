import 'package:flutter/material.dart';
import 'game_tile.dart';

// Represents a tile container in the 3x3 grid (positions 1-9)
class TileContainer {
  final int position; // 1-9 for the 3x3 grid
  final List<Color?> columnColors; // 3 columns, null means transparent/open

  const TileContainer({
    required this.position,
    required this.columnColors,
  });

  // Create an empty tile container
  factory TileContainer.empty(int position) {
    return TileContainer(
      position: position,
      columnColors: [null, null, null],
    );
  }

  // Check if a game tile can be placed on this container
  bool canAcceptTile(GameTile gameTile) {
    for (int i = 0; i < 3; i++) {
      // If the game tile has a color in column i
      if (gameTile.columnColors[i] != null) {
        // But this container already has a color in column i
        if (columnColors[i] != null) {
          return false; // Cannot place - column is occupied
        }
      }
    }
    return true; // Can place - all colored columns from tile fit in open columns
  }

  // Apply a game tile to this container, returning a new container
  TileContainer placeTile(GameTile gameTile) {
    if (!canAcceptTile(gameTile)) {
      throw Exception('Cannot place tile ${gameTile.id} on container $position');
    }

    final newColumnColors = List<Color?>.from(columnColors);
    for (int i = 0; i < 3; i++) {
      if (gameTile.columnColors[i] != null) {
        newColumnColors[i] = gameTile.columnColors[i];
      }
    }

    return copyWith(columnColors: newColumnColors);
  }

  // Check if this container is completely filled
  bool get isFull => columnColors.every((color) => color != null);

  // Get indices of open (transparent) columns
  List<int> get openColumnIndices {
    final openCols = <int>[];
    for (int i = 0; i < 3; i++) {
      if (columnColors[i] == null) {
        openCols.add(i);
      }
    }
    return openCols;
  }

  // Get number of open columns
  int get openColumnCount => openColumnIndices.length;

  TileContainer copyWith({
    int? position,
    List<Color?>? columnColors,
  }) {
    return TileContainer(
      position: position ?? this.position,
      columnColors: columnColors ?? List.from(this.columnColors),
    );
  }
}