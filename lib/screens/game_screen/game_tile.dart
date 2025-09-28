import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import '../../models/game_tile.dart' as model;

class GameTileWidget extends StatelessWidget {
  final model.GameTile gameTile;

  const GameTileWidget({
    super.key,
    required this.gameTile,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<model.GameTile>(
      data: gameTile,
      feedback: Transform.scale(
        scale: 1.2,
        child: Container(
          width: 80, // Fixed size for feedback
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.whiteOpacity(0.8),
              width: 2,
            ),
            color: AppColors.whiteOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: _buildFeedbackColumns(),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildTileContent(),
      ),
      child: _buildTileContent(),
    );
  }

  Widget _buildTileContent() {
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
        children: _buildColumns(),
      ),
    );
  }

  List<Widget> _buildFeedbackColumns() {
    final columnColors = gameTile.columnColors;
    final columnCount = columnColors.length;

    return List.generate(columnCount, (index) {
      final isFirst = index == 0;
      final isLast = index == columnCount - 1;

      return Expanded(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: columnColors[index] ?? Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(10) : Radius.zero,
              bottomLeft: isFirst ? const Radius.circular(10) : Radius.zero,
              topRight: isLast ? const Radius.circular(10) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(10) : Radius.zero,
            ),
            border: Border(
              right: isLast
                  ? BorderSide.none
                  : BorderSide(
                      color: AppColors.whiteOpacity(0.4),
                      width: 1,
                    ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildColumns() {
    final columnColors = gameTile.columnColors;
    final columnCount = columnColors.length;

    return List.generate(columnCount, (index) {
      final isFirst = index == 0;
      final isLast = index == columnCount - 1;

      return Expanded(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: columnColors[index] ?? Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(11) : Radius.zero,
              bottomLeft: isFirst ? const Radius.circular(11) : Radius.zero,
              topRight: isLast ? const Radius.circular(11) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(11) : Radius.zero,
            ),
            border: Border(
              right: isLast
                  ? BorderSide.none
                  : BorderSide(
                      color: AppColors.whiteOpacity(0.2),
                      width: 0.5,
                    ),
            ),
          ),
        ),
      );
    });
  }
}