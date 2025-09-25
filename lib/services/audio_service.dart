import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Use separate players to allow concurrent playback
  static AudioPlayer? _popPlayer;
  static AudioPlayer? _twinklePlayer;
  static bool _soundEffectsEnabled = true;
  static double _masterVolume = 0.8;

  // Sound effect file paths
  static const String _popSound = 'music/effect/pop-39222.mp3';
  static const String _twinkleSound = 'music/effect/sound-effect-twinklesparkle-115095.mp3';

  // Initialize the audio service
  static Future<void> initialize() async {
    _popPlayer = AudioPlayer();
    _twinklePlayer = AudioPlayer();
    await _popPlayer!.setReleaseMode(ReleaseMode.release);
    await _twinklePlayer!.setReleaseMode(ReleaseMode.release);
  }

  // Update settings from settings bloc
  static void updateSettings({
    required bool soundEffectsEnabled,
    required double masterVolume,
  }) {
    _soundEffectsEnabled = soundEffectsEnabled;
    _masterVolume = masterVolume;
  }

  // Play pop sound when tile is dropped without color flush
  static Future<void> playPopSound() async {
    print('AudioService: Attempting to play pop sound. Enabled: $_soundEffectsEnabled, Volume: $_masterVolume');
    if (!_soundEffectsEnabled || _popPlayer == null) {
      print('AudioService: Sound effects disabled or player not initialized, skipping pop sound');
      return;
    }

    try {
      // Stop any currently playing pop sound to allow rapid succession
      await _popPlayer!.stop();
      await _popPlayer!.setVolume(_masterVolume);
      await _popPlayer!.play(AssetSource(_popSound));
      print('AudioService: Pop sound played successfully');
    } catch (e) {
      print('Error playing pop sound: $e');
    }
  }

  // Play twinkle sound when tile is dropped and colors are flushed
  static Future<void> playTwinkleSound() async {
    print('AudioService: Attempting to play twinkle sound. Enabled: $_soundEffectsEnabled, Volume: $_masterVolume');
    if (!_soundEffectsEnabled || _twinklePlayer == null) {
      print('AudioService: Sound effects disabled or player not initialized, skipping twinkle sound');
      return;
    }

    try {
      // Stop any currently playing twinkle sound to allow rapid succession
      await _twinklePlayer!.stop();
      await _twinklePlayer!.setVolume(_masterVolume);
      await _twinklePlayer!.play(AssetSource(_twinkleSound));
      print('AudioService: Twinkle sound played successfully');
    } catch (e) {
      print('Error playing twinkle sound: $e');
    }
  }

  // Dispose of resources
  static void dispose() {
    _popPlayer?.dispose();
    _twinklePlayer?.dispose();
  }
}