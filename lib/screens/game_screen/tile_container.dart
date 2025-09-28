import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import '../../models/tile_container.dart';
import '../../models/game_tile.dart' as model;
import '../../state/game_bloc.dart';
import '../../state/game_event.dart';
import '../../services/animation_service.dart';

class TileContainerWidget extends StatefulWidget {
  final TileContainer tileContainer;

  const TileContainerWidget({
    super.key,
    required this.tileContainer,
  });

  @override
  State<TileContainerWidget> createState() => _TileContainerWidgetState();
}

class _TileContainerWidgetState extends State<TileContainerWidget> {
  List<Color?> _previousColors = [];

  @override
  void initState() {
    super.initState();
    _previousColors = List.from(widget.tileContainer.columnColors);
  }

  @override
  void didUpdateWidget(TileContainerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousColors = List.from(oldWidget.tileContainer.columnColors);
  }

  Duration _getAnimationDuration(int columnIndex) {
    if (columnIndex >= _previousColors.length ||
        columnIndex >= widget.tileContainer.columnColors.length) {
      return Duration.zero;
    }

    final previousColor = _previousColors[columnIndex];
    final currentColor = widget.tileContainer.columnColors[columnIndex];

    // Only animate when going from color to transparent (fade out)
    if (previousColor != null && currentColor == null) {
      return AnimationService.getDuration(const Duration(milliseconds: 550));
    }

    // Instant for all other changes (adding colors)
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<model.GameTile>(
      onWillAcceptWithDetails: (details) {
        return widget.tileContainer.canAcceptTile(details.data);
      },
      onAcceptWithDetails: (details) {
        context.read<GameBloc>().add(TilePlaced(
          gameTileId: details.data.id,
          containerPosition: widget.tileContainer.position,
        ));
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        final canAccept = candidateData.isNotEmpty &&
                         widget.tileContainer.canAcceptTile(candidateData.first!);

        return AnimatedContainer(
          duration: AnimationService.getDuration(const Duration(milliseconds: 200)),
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
            children: _buildColumns(),
          ),
        );
      },
    );
  }

  List<Widget> _buildColumns() {
    final columnColors = widget.tileContainer.columnColors;
    final columnCount = columnColors.length;

    return List.generate(columnCount, (index) {
      final isFirst = index == 0;
      final isLast = index == columnCount - 1;

      return Expanded(
        child: AnimatedContainer(
          duration: _getAnimationDuration(index),
          curve: AnimationService.getCurve(Curves.easeOut),
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