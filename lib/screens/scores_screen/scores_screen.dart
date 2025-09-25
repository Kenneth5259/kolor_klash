import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import 'package:kolor_klash/models/score_entry.dart';
import 'package:kolor_klash/services/score_service.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<ScoreEntry> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadScores();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadScores() async {
    final scores = await ScoreService.getScores();
    setState(() {
      _scores = scores;
      _isLoading = false;
    });
    _animationController.forward();
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
              // Header
              _buildHeader(),
              const SizedBox(height: 20),

              // Scores List
              Expanded(
                child: _buildScoresList(),
              ),

              const SizedBox(height: 20),

              // Back Button
              AppTheme.buildSecondaryButton(
                text: 'BACK',
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).pop(),
              ),
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

        // Title
        Text(
          'HIGH SCORES',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),

        // Clear Button
        IconButton(
          onPressed: _showClearDialog,
          icon: Icon(
            Icons.delete_outline,
            color: AppColors.whiteOpacity(0.8),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildScoresList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.whiteOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No scores yet!',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.whiteOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Play a game to see your scores here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.whiteOpacity(0.4),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.whiteOpacity(0.1),
          width: 2,
        ),
        color: AppColors.whiteOpacity(0.05),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          final score = _scores[index];
          final isTopScore = index == 0;

          return _buildScoreItem(score, index + 1, isTopScore);
        },
      ),
    );
  }

  Widget _buildScoreItem(ScoreEntry score, int rank, bool isTopScore) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isTopScore
            ? AppColors.whiteOpacity(0.15)
            : AppColors.whiteOpacity(0.08),
        border: isTopScore
            ? Border.all(color: AppColors.whiteOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTopScore
                  ? AppColors.whiteOpacity(0.3)
                  : AppColors.whiteOpacity(0.15),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Score and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  score.score.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  score.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.whiteOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Trophy for top score
          if (isTopScore)
            Icon(
              Icons.emoji_events,
              color: AppColors.whiteOpacity(0.8),
              size: 24,
            ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteOpacity(0.9),
        title: const Text('Clear Scores'),
        content: const Text('Are you sure you want to clear all scores?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearScores();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _clearScores() async {
    await ScoreService.clearScores();
    _loadScores();
  }
}