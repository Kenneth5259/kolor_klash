abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class MusicToggled extends SettingsEvent {
  final bool enabled;

  MusicToggled(this.enabled);
}

class SoundEffectsToggled extends SettingsEvent {
  final bool enabled;

  SoundEffectsToggled(this.enabled);
}

class MasterVolumeChanged extends SettingsEvent {
  final double volume;

  MasterVolumeChanged(this.volume);
}

class AnimationsToggled extends SettingsEvent {
  final bool enabled;

  AnimationsToggled(this.enabled);
}