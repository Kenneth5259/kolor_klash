import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static Map<String, dynamic>? _localizedStrings;
  static String _currentLanguage = 'en';

  static Future<void> load(String languageCode) async {
    _currentLanguage = languageCode;
    final jsonString = await rootBundle.loadString('assets/locales/$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap;
  }

  static String translate(String key) {
    if (_localizedStrings == null) {
      return key;
    }

    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // Return the key if translation not found
      }
    }

    return value?.toString() ?? key;
  }

  static String get currentLanguage => _currentLanguage;

  // Convenience getters for common translations
  static String get appSubtitle => translate('app.subtitle');
  static String get appVersion => translate('app.version');

  // Home screen
  static String get homeStartGame => translate('home.startGame');
  static String get homeSettings => translate('home.settings');
  static String get homeScores => translate('home.scores');

  // Game screen
  static String get gameScore => translate('game.score');
  static String get gameDeck => translate('game.deck');
  static String get gamePause => translate('game.pause');
  static String get gameReroll => translate('game.reroll');
  static String get gameGameOver => translate('game.gameOver');
  static String get gameFinalScore => translate('game.finalScore');
  static String get gameStartNewGame => translate('game.startNewGame');

  // Scores screen
  static String get scoresTitle => translate('scores.title');
  static String get scoresBack => translate('scores.back');
  static String get scoresNoScores => translate('scores.noScores');
  static String get scoresNoScoresSubtitle => translate('scores.noScoresSubtitle');
  static String get scoresClearScores => translate('scores.clearScores');
  static String get scoresClearConfirmation => translate('scores.clearConfirmation');
  static String get scoresCancel => translate('scores.cancel');
  static String get scoresClear => translate('scores.clear');

  // Settings screen
  static String get settingsTitle => translate('settings.title');
  static String get settingsAudioSection => translate('settings.sections.audio');
  static String get settingsGameplaySection => translate('settings.sections.gameplay');
  static String get settingsPreferencesSection => translate('settings.sections.preferences');
  static String get settingsSoundEffects => translate('settings.audio.soundEffects');
  static String get settingsMusic => translate('settings.audio.music');
  static String get settingsMasterVolume => translate('settings.audio.masterVolume');
  static String get settingsDifficulty => translate('settings.gameplay.difficulty');
  static String get settingsAnimations => translate('settings.gameplay.animations');
  static String get settingsLanguage => translate('settings.preferences.language');
  static String get settingsErrorLoading => translate('settings.errors.loading');

  // Common
  static String get commonLoading => translate('common.loading');

  // Methods for dynamic text
  static String gameRerollWithCount(int count) => '${translate('game.reroll')} ($count)';
}