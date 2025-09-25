abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool musicEnabled;
  final bool soundEffectsEnabled;
  final double masterVolume;

  SettingsLoaded({
    required this.musicEnabled,
    required this.soundEffectsEnabled,
    required this.masterVolume,
  });

  factory SettingsLoaded.initial() {
    return SettingsLoaded(
      musicEnabled: true,
      soundEffectsEnabled: true,
      masterVolume: 0.8,
    );
  }

  SettingsLoaded copyWith({
    bool? musicEnabled,
    bool? soundEffectsEnabled,
    double? masterVolume,
  }) {
    return SettingsLoaded(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      masterVolume: masterVolume ?? this.masterVolume,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}