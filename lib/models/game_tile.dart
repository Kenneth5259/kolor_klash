import 'package:flutter/material.dart';
import 'dart:math';
import 'game_difficulty.dart';

// Game colors available for tiles
class GameColors {
  static const List<Color> colors = [
    Color(0xFFE74C3C), // Red
    Color(0xFF3498DB), // Blue
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFF1ABC9C), // Teal
    Color(0xFFE67E22), // Dark Orange
    Color(0xFFF1C40F), // Yellow
  ];
}

// Represents a game tile from the deck (D1, D2, D3)
class GameTile {
  final String id;
  final List<Color?> columnColors; // 3 or 4 columns depending on difficulty, null means transparent

  const GameTile({
    required this.id,
    required this.columnColors,
  });

  // Generate a random game tile based on difficulty
  factory GameTile.random(String id, [GameDifficulty? difficulty]) {
    final gameDifficulty = difficulty ?? GameDifficulty.normal;
    final random = Random();
    final columnCount = gameDifficulty.columnCount;
    final minColors = gameDifficulty.minDeckTileColors;
    final maxColors = gameDifficulty.maxDeckTileColors;

    final numColoredColumns = random.nextInt(maxColors - minColors + 1) + minColors;
    final List<Color?> columnColors = List.filled(columnCount, null);

    // Get random positions for colored columns
    final positions = <int>[];
    while (positions.length < numColoredColumns) {
      final pos = random.nextInt(columnCount);
      if (!positions.contains(pos)) {
        positions.add(pos);
      }
    }

    // Assign random colors to selected positions
    for (final pos in positions) {
      columnColors[pos] = GameColors.colors[random.nextInt(GameColors.colors.length)];
    }

    return GameTile(
      id: id,
      columnColors: columnColors,
    );
  }

  GameTile copyWith({
    String? id,
    List<Color?>? columnColors,
  }) {
    return GameTile(
      id: id ?? this.id,
      columnColors: columnColors ?? List.from(this.columnColors),
    );
  }
}