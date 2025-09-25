import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score_entry.dart';

class ScoreService {
  static const String _scoresKey = 'kolor_klash_scores';
  static const int _maxScores = 50; // Keep top 50 scores

  // Get all saved scores
  static Future<List<ScoreEntry>> getScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = prefs.getStringList(_scoresKey) ?? [];

      final scores = scoresJson
          .map((jsonString) => ScoreEntry.fromJson(jsonDecode(jsonString)))
          .toList();

      // Sort by score (highest first), then by date (newest first)
      scores.sort((a, b) {
        final scoreComparison = b.score.compareTo(a.score);
        if (scoreComparison != 0) return scoreComparison;
        return b.timestamp.compareTo(a.timestamp);
      });

      return scores;
    } catch (e) {
      print('Error loading scores: $e');
      return [];
    }
  }

  // Save a new score
  static Future<void> saveScore(int score) async {
    try {
      final scores = await getScores();

      // Add new score
      scores.add(ScoreEntry(
        score: score,
        timestamp: DateTime.now(),
      ));

      // Sort and keep only top scores
      scores.sort((a, b) {
        final scoreComparison = b.score.compareTo(a.score);
        if (scoreComparison != 0) return scoreComparison;
        return b.timestamp.compareTo(a.timestamp);
      });

      // Keep only top scores
      if (scores.length > _maxScores) {
        scores.removeRange(_maxScores, scores.length);
      }

      // Save back to preferences
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = scores
          .map((score) => jsonEncode(score.toJson()))
          .toList();

      await prefs.setStringList(_scoresKey, scoresJson);
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  // Get highest score
  static Future<int> getHighScore() async {
    final scores = await getScores();
    return scores.isEmpty ? 0 : scores.first.score;
  }

  // Clear all scores (for settings/testing)
  static Future<void> clearScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scoresKey);
    } catch (e) {
      print('Error clearing scores: $e');
    }
  }
}