import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/theme/app_theme.dart';
import 'package:kolor_klash/theme/app_text_styles.dart';
import 'package:kolor_klash/theme/app_colors.dart';
import '../../state/settings_bloc.dart';
import '../../state/settings_event.dart';
import '../../state/settings_state.dart';
import '../../services/animation_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  // Static method to create the screen (now just returns the screen since bloc is provided at app level)
  static Widget create() {
    return const SettingsScreen();
  }
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  String _selectedLanguage = 'English';
  bool _vibration = true;
  String _difficulty = 'Normal';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Chinese',
  ];

  final List<String> _difficulties = [
    'Easy',
    'Normal',
    'Hard',
    'Expert',
  ];

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
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading || state is SettingsInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPurple,
                      ),
                    );
                  }

                  if (state is SettingsError) {
                    return Center(
                      child: Text(
                        'Error loading settings: ${state.message}',
                        style: AppTextStyles.secondaryButton,
                      ),
                    );
                  }

                  if (state is! SettingsLoaded) {
                    return const SizedBox.shrink();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Audio Settings'),
                        const SizedBox(height: 16),
                        _buildAudioSettings(state),
                        const SizedBox(height: 32),

                        _buildSectionTitle('Gameplay Settings'),
                        const SizedBox(height: 16),
                        _buildGameplaySettings(state),
                        const SizedBox(height: 32),

                        _buildSectionTitle('Preferences'),
                        const SizedBox(height: 16),
                        _buildPreferences(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.whiteOpacity(0.8),
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          AppTheme.buildGradientText(
            text: 'SETTINGS',
            style: AppTextStyles.gameTitle.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.subtitle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildAudioSettings(SettingsLoaded settings) {
    return Column(
      children: [
        _buildSwitchSetting(
          'Sound Effects',
          settings.soundEffectsEnabled,
          (value) => context.read<SettingsBloc>().add(SoundEffectsToggled(value)),
          Icons.volume_up,
        ),
        const SizedBox(height: 16),

        _buildSwitchSetting(
          'Music',
          settings.musicEnabled,
          (value) => context.read<SettingsBloc>().add(MusicToggled(value)),
          Icons.music_note,
        ),
        const SizedBox(height: 16),

        _buildSliderSetting(
          'Master Volume',
          settings.masterVolume,
          (value) => context.read<SettingsBloc>().add(MasterVolumeChanged(value)),
          Icons.volume_down,
          Icons.volume_up,
        ),
      ],
    );
  }

  Widget _buildGameplaySettings(SettingsLoaded settings) {
    return Column(
      children: [
        _buildDropdownSetting(
          'Difficulty',
          _difficulty,
          _difficulties,
          (value) => setState(() => _difficulty = value!),
          Icons.speed,
        ),
        const SizedBox(height: 16),

        _buildSwitchSetting(
          'Vibration',
          _vibration,
          (value) => setState(() => _vibration = value),
          Icons.vibration,
        ),
        const SizedBox(height: 16),

        _buildSwitchSetting(
          'Animations',
          settings.animationsEnabled,
          (value) => context.read<SettingsBloc>().add(AnimationsToggled(value)),
          Icons.animation,
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return Column(
      children: [
        _buildDropdownSetting(
          'Language',
          _selectedLanguage,
          _languages,
          (value) => setState(() => _selectedLanguage = value!),
          Icons.language,
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.whiteOpacity(0.1),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.whiteOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.secondaryButton.copyWith(fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryPurple,
            activeTrackColor: AppColors.primaryPurpleOpacity(0.3),
            inactiveThumbColor: AppColors.whiteOpacity(0.4),
            inactiveTrackColor: AppColors.whiteOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    ValueChanged<double> onChanged,
    IconData minIcon,
    IconData maxIcon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.whiteOpacity(0.1),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.secondaryButton.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                minIcon,
                color: AppColors.whiteOpacity(0.5),
                size: 20,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.primaryPurple,
                    inactiveTrackColor: AppColors.whiteOpacity(0.2),
                    thumbColor: AppColors.primaryPurple,
                    overlayColor: AppColors.primaryPurpleOpacity(0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: value,
                    onChanged: onChanged,
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
              ),
              Icon(
                maxIcon,
                color: AppColors.whiteOpacity(0.5),
                size: 20,
              ),
            ],
          ),
          Text(
            '${(value * 100).round()}%',
            style: AppTextStyles.versionText.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting<T>(
    String title,
    T value,
    List<T> options,
    ValueChanged<T?> onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.whiteOpacity(0.1),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.whiteOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.secondaryButton.copyWith(fontSize: 16),
            ),
          ),
          DropdownButton<T>(
            value: value,
            onChanged: onChanged,
            dropdownColor: AppColors.darkBackground,
            iconEnabledColor: AppColors.whiteOpacity(0.7),
            underline: Container(),
            items: options.map((T option) {
              return DropdownMenuItem<T>(
                value: option,
                child: Text(
                  option.toString(),
                  style: AppTextStyles.secondaryButton.copyWith(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}