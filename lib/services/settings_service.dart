import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_difficulty.dart';

class SettingsService {
  static const String _musicKey = 'music_enabled';
  static const String _soundEffectsKey = 'sound_effects_enabled';
  static const String _masterVolumeKey = 'master_volume';
  static const String _animationsKey = 'animations_enabled';
  static const String _languageKey = 'language';
  static const String _difficultyKey = 'game_difficulty';

  static Future<bool> getMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_musicKey) ?? true;
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicKey, enabled);
  }

  static Future<bool> getSoundEffectsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEffectsKey) ?? true;
  }

  static Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  static Future<double> getMasterVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_masterVolumeKey) ?? 0.8;
  }

  static Future<void> setMasterVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_masterVolumeKey, volume);
  }

  static Future<bool> getAnimationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_animationsKey) ?? true;
  }

  static Future<void> setAnimationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_animationsKey, enabled);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<GameDifficulty> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final difficultyString = prefs.getString(_difficultyKey) ?? 'normal';
    return GameDifficulty.fromString(difficultyString);
  }

  static Future<void> setDifficulty(GameDifficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty.name);
  }

  static Future<Map<String, dynamic>> loadAllSettings() async {
    final musicEnabled = await getMusicEnabled();
    final soundEffectsEnabled = await getSoundEffectsEnabled();
    final masterVolume = await getMasterVolume();
    final animationsEnabled = await getAnimationsEnabled();
    final language = await getLanguage();
    final difficulty = await getDifficulty();

    return {
      'musicEnabled': musicEnabled,
      'soundEffectsEnabled': soundEffectsEnabled,
      'masterVolume': masterVolume,
      'animationsEnabled': animationsEnabled,
      'language': language,
      'difficulty': difficulty,
    };
  }
}