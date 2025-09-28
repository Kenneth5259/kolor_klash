import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_text_styles.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import 'package:kolor_klash/screens/game_screen/game_screen.dart';
import 'package:kolor_klash/screens/scores_screen/scores_screen.dart';
import 'package:kolor_klash/screens/settings_screen/settings_screen.dart';
import 'package:kolor_klash/state/settings_bloc.dart';
import 'package:kolor_klash/state/settings_state.dart';
import '../../services/animation_service.dart';
import '../../services/localization_service.dart';
import '../../services/game_persistence_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationService.getDuration(const Duration(milliseconds: 1500)),
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
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const Spacer(flex: 2),

              // Game Title
              AppTheme.buildGradientText(
                text: 'KOLOR KLASH',
                style: AppTextStyles.gameTitle,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Match • Merge • Master',
                style: AppTextStyles.subtitle,
              ),

              const Spacer(flex: 3),

              // Play Button
              AppTheme.buildPrimaryButton(
                text: LocalizationService.homeStartGame,
                onPressed: () => _handleStartGame(context),
                width: double.infinity,
              ),

              const SizedBox(height: 24),

              // Secondary Buttons
              Row(
                children: [
                  Expanded(
                    child: AppTheme.buildSecondaryButton(
                      text: LocalizationService.homeSettings,
                      icon: Icons.settings,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen.create(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTheme.buildSecondaryButton(
                      text: LocalizationService.homeScores,
                      icon: Icons.leaderboard,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScoresScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Version Info
              Text(
                LocalizationService.appVersion,
                style: AppTextStyles.versionText,
              ),

              const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleStartGame(BuildContext context) async {
    final hasSavedGame = await GamePersistenceService.hasSavedGame();

    if (!mounted) return;

    if (hasSavedGame) {
      _showResumeGameDialog(context);
    } else {
      _startNewGame(context);
    }
  }

  void _showResumeGameDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.whiteOpacity(0.2),
            width: 1,
          ),
        ),
        title: AppTheme.buildGradientText(
          text: 'Continue Game?',
          style: AppTextStyles.gameTitle.copyWith(fontSize: 20),
        ),
        content: Text(
          'You have a saved game in progress. Would you like to continue or start a new game?',
          style: AppTextStyles.secondaryButton.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewGame(context);
            },
            child: Text(
              'New Game',
              style: AppTextStyles.secondaryButton.copyWith(
                color: AppColors.whiteOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Continue',
              style: AppTextStyles.primaryButton.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _startNewGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen.createNew(),
      ),
    );
  }

  void _resumeGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen.createResume(),
      ),
    );
  }
}