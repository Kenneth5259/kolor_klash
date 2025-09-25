import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import 'package:kolor_klash/state/game_bloc.dart';
import 'package:kolor_klash/state/game_state.dart';
import 'package:kolor_klash/state/game_event.dart';
import '../../services/animation_service.dart';
import 'tile_container.dart';
import 'game_tile.dart' show GameTileWidget;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();

  // Static method to create the screen with BlocProvider
  static Widget create() {
    return BlocProvider(
      create: (context) => GameBloc()..add(GameStarted()),
      child: const GameScreen(),
    );
  }
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationService.getDuration(const Duration(milliseconds: 1200)),
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
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        int score = 0;
        if (state is GameInProgress) {
          score = state.score;
        } else if (state is GameOver) {
          score = state.finalScore;
        }

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
                  score.toString(),
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
                context.read<GameBloc>().add(GameReset());
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.whiteOpacity(0.8),
                size: 24,
              ),
            ),
          ],
        );
      },
    );
  }

  double _calculateTileSize(double availableWidth) {
    final containerPadding = 32.0; // 16 padding on each side
    final adjustedWidth = availableWidth - containerPadding;
    return (adjustedWidth - 16) / 3; // 16 for spacing (2 gaps of 8px)
  }

  Widget _buildGameGrid() {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final tileSize = _calculateTileSize(constraints.maxWidth);
            final gridSize = tileSize * 3 + 16; // 3 tiles + 2 gaps
            final containerSize = gridSize + 32; // grid + padding on all sides

            return Container(
              width: containerSize,
              height: containerSize,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.whiteOpacity(0.1),
                  width: 2,
                ),
                color: AppColors.whiteOpacity(0.05),
              ),
              child: _buildGridContent(state, gridSize),
            );
          },
        );
      },
    );
  }

  Widget _buildGridContent(GameState state, double gridSize) {
    if (state is GameOver) {
      return _buildGameOverOverlay(state);
    }

    if (state is GameInProgress) {
      return SizedBox(
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
          itemBuilder: (context, index) => TileContainerWidget(
            tileContainer: state.grid[index],
          ),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGameOverOverlay(GameOver gameOverState) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.whiteOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'GAME OVER',
            style: TextStyle(
              fontSize: 28,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'FINAL SCORE',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.whiteOpacity(0.6),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gameOverState.finalScore.toString(),
            style: TextStyle(
              fontSize: 48,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<GameBloc>().add(GameReset());
            },
            icon: Icon(
              Icons.refresh,
              color: AppColors.white,
              size: 20,
            ),
            label: Text(
              'START NEW GAME',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.whiteOpacity(0.2),
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.whiteOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDeckSection() {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is! GameInProgress) {
          return const SizedBox.shrink();
        }

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
                        for (int i = 0; i < state.deck.tiles.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          SizedBox(
                            width: deckTileSize,
                            height: deckTileSize,
                            child: GameTileWidget(gameTile: state.deck.tiles[i]),
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
      },
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
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              final rerollsAvailable = state is GameInProgress ? state.rerollsAvailable : 0;
              final canReroll = rerollsAvailable > 0;

              return Opacity(
                opacity: canReroll ? 1.0 : 0.5,
                child: AppTheme.buildSecondaryButton(
                  text: 'REROLL ($rerollsAvailable)',
                  icon: Icons.casino,
                  onPressed: () {
                    if (canReroll) {
                      context.read<GameBloc>().add(DeckRerolled());
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}