enum GameDifficulty {
  easy,
  normal,
  hard,
  expert;

  int get columnCount {
    switch (this) {
      case GameDifficulty.easy:
      case GameDifficulty.normal:
        return 3;
      case GameDifficulty.hard:
      case GameDifficulty.expert:
        return 4;
    }
  }

  int get minDeckTileColors {
    switch (this) {
      case GameDifficulty.easy:
        return 1;
      case GameDifficulty.normal:
        return 1;
      case GameDifficulty.hard:
        return 1;
      case GameDifficulty.expert:
        return 2;
    }
  }

  int get maxDeckTileColors {
    switch (this) {
      case GameDifficulty.easy:
        return 1;
      case GameDifficulty.normal:
        return 2;
      case GameDifficulty.hard:
        return 3;
      case GameDifficulty.expert:
        return 4;
    }
  }

  String get displayName {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.normal:
        return 'Normal';
      case GameDifficulty.hard:
        return 'Hard';
      case GameDifficulty.expert:
        return 'Expert';
    }
  }

  static GameDifficulty fromString(String value) {
    return GameDifficulty.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GameDifficulty.normal,
    );
  }
}