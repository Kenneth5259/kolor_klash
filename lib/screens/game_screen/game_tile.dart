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
            children: [
              // Column 1
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: gameTile.columnColors[0] ?? Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border(
                      right: BorderSide(
                        color: AppColors.whiteOpacity(0.4),
                        width: 1,
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
                    color: gameTile.columnColors[1] ?? Colors.transparent,
                    border: Border(
                      right: BorderSide(
                        color: AppColors.whiteOpacity(0.4),
                        width: 1,
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
                    color: gameTile.columnColors[2] ?? Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
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
        children: [
          // Column 1
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: gameTile.columnColors[0] ?? Colors.transparent,
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
                color: gameTile.columnColors[1] ?? Colors.transparent,
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
                color: gameTile.columnColors[2] ?? Colors.transparent,
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