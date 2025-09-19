import 'package:flutter/material.dart';
import 'dart:math';

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
  final List<Color?> columnColors; // 3 columns, null means transparent

  const GameTile({
    required this.id,
    required this.columnColors,
  });

  // Generate a random game tile with 1-2 colored columns
  factory GameTile.random(String id) {
    final random = Random();
    final numColoredColumns = random.nextInt(2) + 1; // 1 or 2 colored columns
    final List<Color?> columnColors = [null, null, null];

    // Get random positions for colored columns
    final positions = <int>[];
    while (positions.length < numColoredColumns) {
      final pos = random.nextInt(3);
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