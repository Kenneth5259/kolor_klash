import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/game_difficulty.dart';
import '../services/settings_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<MusicToggled>(_onMusicToggled);
    on<SoundEffectsToggled>(_onSoundEffectsToggled);
    on<MasterVolumeChanged>(_onMasterVolumeChanged);
    on<AnimationsToggled>(_onAnimationsToggled);
    on<LanguageChanged>(_onLanguageChanged);
    on<DifficultyChanged>(_onDifficultyChanged);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      final settings = await SettingsService.loadAllSettings();

      emit(SettingsLoaded(
        musicEnabled: settings['musicEnabled'],
        soundEffectsEnabled: settings['soundEffectsEnabled'],
        masterVolume: settings['masterVolume'],
        animationsEnabled: settings['animationsEnabled'],
        language: settings['language'],
        difficulty: settings['difficulty'] ?? GameDifficulty.normal,
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

  Future<void> _onAnimationsToggled(AnimationsToggled event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setAnimationsEnabled(event.enabled);

        emit(currentState.copyWith(animationsEnabled: event.enabled));
      } catch (error) {
        emit(SettingsError('Failed to update animations setting: $error'));
      }
    }
  }

  Future<void> _onLanguageChanged(LanguageChanged event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setLanguage(event.languageCode);

        emit(currentState.copyWith(language: event.languageCode));
      } catch (error) {
        emit(SettingsError('Failed to update language setting: $error'));
      }
    }
  }

  Future<void> _onDifficultyChanged(DifficultyChanged event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await SettingsService.setDifficulty(event.difficulty);

        emit(currentState.copyWith(difficulty: event.difficulty));
      } catch (error) {
        emit(SettingsError('Failed to update difficulty setting: $error'));
      }
    }
  }
}