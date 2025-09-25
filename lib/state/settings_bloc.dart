import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/settings_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<MusicToggled>(_onMusicToggled);
    on<SoundEffectsToggled>(_onSoundEffectsToggled);
    on<MasterVolumeChanged>(_onMasterVolumeChanged);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      final settings = await SettingsService.loadAllSettings();

      emit(SettingsLoaded(
        musicEnabled: settings['musicEnabled'],
        soundEffectsEnabled: settings['soundEffectsEnabled'],
        masterVolume: settings['masterVolume'],
      ));
    } catch (error) {
      emit(SettingsError('Failed to load settings: $error'));
    }
  }

  Future<void> _onMusicToggled(MusicToggled event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setMusicEnabled(event.enabled);

        emit(currentState.copyWith(musicEnabled: event.enabled));
      } catch (error) {
        emit(SettingsError('Failed to update music setting: $error'));
      }
    }
  }

  Future<void> _onSoundEffectsToggled(SoundEffectsToggled event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setSoundEffectsEnabled(event.enabled);

        emit(currentState.copyWith(soundEffectsEnabled: event.enabled));
      } catch (error) {
        emit(SettingsError('Failed to update sound effects setting: $error'));
      }
    }
  }

  Future<void> _onMasterVolumeChanged(MasterVolumeChanged event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setMasterVolume(event.volume);

        emit(currentState.copyWith(masterVolume: event.volume));
      } catch (error) {
        emit(SettingsError('Failed to update master volume: $error'));
      }
    }
  }
}