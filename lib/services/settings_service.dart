import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _musicKey = 'music_enabled';
  static const String _soundEffectsKey = 'sound_effects_enabled';
  static const String _masterVolumeKey = 'master_volume';

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

  static Future<Map<String, dynamic>> loadAllSettings() async {
    final musicEnabled = await getMusicEnabled();
    final soundEffectsEnabled = await getSoundEffectsEnabled();
    final masterVolume = await getMasterVolume();

    return {
      'musicEnabled': musicEnabled,
      'soundEffectsEnabled': soundEffectsEnabled,
      'masterVolume': masterVolume,
    };
  }
}