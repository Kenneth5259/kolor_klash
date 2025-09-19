import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import 'tile_container.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.buildScreenContainer(
      child: AppTheme.buildFadeTransition(
        controller: _animationController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              const SizedBox(height: 20),

              // Game Grid (3x3)
              _buildGameGrid(),

              const Spacer(),

              // Deck Section (1x3)
              _buildDeckSection(),

              const SizedBox(height: 20),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteOpacity(0.8),
            size: 24,
          ),
        ),

        // Score
        Column(
          children: [
            Text(
              'SCORE',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.whiteOpacity(0.6),
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '1,250',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),

        // Menu Button
        IconButton(
          onPressed: () {
            // Show game menu
          },
          icon: Icon(
            Icons.menu,
            color: AppColors.whiteOpacity(0.8),
            size: 24,
          ),
        ),
      ],
    );
  }

  double _calculateTileSize(double availableWidth) {
    final containerPadding = 32.0; // 16 padding on each side
    final adjustedWidth = availableWidth - containerPadding;
    return (adjustedWidth - 16) / 3; // 16 for spacing (2 gaps of 8px)
  }

  Widget _buildGameGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize = _calculateTileSize(constraints.maxWidth);
        final gridSize = tileSize * 3 + 16; // 3 tiles + 2 gaps
        final containerSize = gridSize + 32; // grid + padding on all sides

        return Container(
          width: containerSize,
          height: containerSize, // Make the container significantly shorter
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.whiteOpacity(0.1),
              width: 2,
            ),
            color: AppColors.whiteOpacity(0.05),
          ),
          child: SizedBox(
            width: gridSize,
            height: gridSize,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => TileContainer(tileNumber: index + 1),
            ),
          ),
        );
      },
    );
  }


  Widget _buildDeckSection() {
    return Column(
      children: [
        Text(
          'DECK',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.whiteOpacity(0.6),
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.whiteOpacity(0.1),
              width: 2,
            ),
            color: AppColors.whiteOpacity(0.05),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate tile size to fit within this container's available width
              final availableWidth = constraints.maxWidth; // Already accounts for container padding
              final tileSpacing = 16.0; // 2 gaps of 8px
              final deckTileSize = (availableWidth - tileSpacing) / 3;

              return SizedBox(
                height: deckTileSize, // Make container height match tile size
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      SizedBox(
                        width: deckTileSize,
                        height: deckTileSize,
                        child: _buildDeckTile(i),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeckTile(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.whiteOpacity(0.3),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.1),
      ),
      child: Center(
        child: Text(
          'D${index + 1}',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.whiteOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppTheme.buildSecondaryButton(
            text: 'PAUSE',
            icon: Icons.pause,
            onPressed: () {
              // Pause game logic
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTheme.buildSecondaryButton(
            text: 'HINT',
            icon: Icons.lightbulb_outline,
            onPressed: () {
              // Show hint logic
            },
          ),
        ),
      ],
    );
  }
}