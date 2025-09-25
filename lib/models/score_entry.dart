class ScoreEntry {
  final int score;
  final DateTime timestamp;

  ScoreEntry({
    required this.score,
    required this.timestamp,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      score: json['score'] as int,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  // Format date for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}