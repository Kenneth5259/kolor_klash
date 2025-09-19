import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import 'dart:math';

class GameTile extends StatelessWidget {
  final String tileId;

  const GameTile({
    super.key,
    required this.tileId,
  });

  // 8 theme color options
  static const List<Color> _gameColors = [
    Color(0xFFE74C3C), // Red
    Color(0xFF3498DB), // Blue
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFF1ABC9C), // Teal
    Color(0xFFE67E22), // Dark Orange
    Color(0xFFF1C40F), // Yellow
  ];

  List<Color?> _generateRandomColors() {
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
      columnColors[pos] = _gameColors[random.nextInt(_gameColors.length)];
    }

    return columnColors;
  }

  @override
  Widget build(BuildContext context) {
    final columnColors = _generateRandomColors();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.whiteOpacity(0.3),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.1),
      ),
      child: Row(
        children: [
          // Column 1
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: columnColors[0] ?? Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
                border: Border(
                  right: BorderSide(
                    color: AppColors.whiteOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          // Column 2
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: columnColors[1] ?? Colors.transparent,
                border: Border(
                  right: BorderSide(
                    color: AppColors.whiteOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          // Column 3
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: columnColors[2] ?? Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}