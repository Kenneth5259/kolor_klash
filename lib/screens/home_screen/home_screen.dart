import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_text_styles.dart';
import 'package:kolor_klash/screens/game_screen/game_screen.dart';
import 'package:kolor_klash/screens/scores_screen/scores_screen.dart';
import 'package:kolor_klash/screens/settings_screen/settings_screen.dart';
import '../../services/animation_service.dart';

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
        child: Padding(
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
                text: 'START GAME',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GameScreen.create(),
                    ),
                  );
                },
                width: double.infinity,
              ),

              const SizedBox(height: 24),

              // Secondary Buttons
              Row(
                children: [
                  Expanded(
                    child: AppTheme.buildSecondaryButton(
                      text: 'SETTINGS',
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
                      text: 'SCORES',
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
                'Version 2.0.0',
                style: AppTextStyles.versionText,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}