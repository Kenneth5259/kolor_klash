import '../models/game_difficulty.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool musicEnabled;
  final bool soundEffectsEnabled;
  final double masterVolume;
  final bool animationsEnabled;
  final String language;
  final GameDifficulty difficulty;

  SettingsLoaded({
    required this.musicEnabled,
    required this.soundEffectsEnabled,
    required this.masterVolume,
    required this.animationsEnabled,
    required this.language,
    this.difficulty = GameDifficulty.normal,
  });

  factory SettingsLoaded.initial() {
    return SettingsLoaded(
      musicEnabled: true,
      soundEffectsEnabled: true,
      masterVolume: 0.8,
      animationsEnabled: true,
      language: 'en',
    );
  }

  SettingsLoaded copyWith({
    bool? musicEnabled,
    bool? soundEffectsEnabled,
    double? masterVolume,
    bool? animationsEnabled,
    String? language,
    GameDifficulty? difficulty,
  }) {
    return SettingsLoaded(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      masterVolume: masterVolume ?? this.masterVolume,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}