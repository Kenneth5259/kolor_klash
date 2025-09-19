import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import '../../models/tile_container.dart';
import '../../models/game_tile.dart' as model;
import '../../state/game_bloc.dart';
import '../../state/game_event.dart';

class TileContainerWidget extends StatelessWidget {
  final TileContainer tileContainer;

  const TileContainerWidget({
    super.key,
    required this.tileContainer,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<model.GameTile>(
      onWillAcceptWithDetails: (details) {
        return tileContainer.canAcceptTile(details.data);
      },
      onAcceptWithDetails: (details) {
        context.read<GameBloc>().add(TilePlaced(
          gameTileId: details.data.id,
          containerPosition: tileContainer.position,
        ));
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        final canAccept = candidateData.isNotEmpty &&
                         tileContainer.canAcceptTile(candidateData.first!);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlighted
                ? (canAccept
                    ? AppColors.whiteOpacity(0.6)
                    : Colors.red.withValues(alpha: 0.6))
                : AppColors.whiteOpacity(0.2),
              width: isHighlighted ? 2 : 1,
            ),
            color: AppColors.whiteOpacity(0.08),
          ),
          child: Row(
            children: [
              // Column 1
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: tileContainer.columnColors[0] ?? Colors.transparent,
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
                    color: tileContainer.columnColors[1] ?? Colors.transparent,
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
                    color: tileContainer.columnColors[2] ?? Colors.transparent,
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
      },
    );
  }
}