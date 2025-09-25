import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kolor_klash/screens/home_screen/home_screen.dart';
import 'package:kolor_klash/state/settings_bloc.dart';
import 'package:kolor_klash/state/settings_event.dart';
import 'package:kolor_klash/state/settings_state.dart';
import 'package:kolor_klash/services/audio_service.dart';
import 'package:kolor_klash/services/animation_service.dart';
import 'package:kolor_klash/services/localization_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await AudioService.initialize();
  await LocalizationService.load('en');

  final backgroundPlayer = AudioPlayer();
  final backgroundSongs = [
    'music/background/inspirational-background-112290.mp3',
    'music/background/that-background-ambient-114376.mp3',
    'music/background/upbeat-day-190084.mp3'
  ];


  runApp(MyApp(backgroundPlayer: backgroundPlayer, backgroundSongs: backgroundSongs));
}

class MyApp extends StatefulWidget {
  final AudioPlayer backgroundPlayer;
  final List<String> backgroundSongs;

  const MyApp({super.key, required this.backgroundPlayer, required this.backgroundSongs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SettingsBloc _settingsBloc;
  bool _isPlaying = false;
  int _currentSongIndex = 0;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc()..add(LoadSettings());
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    widget.backgroundPlayer.dispose();
    _settingsBloc.close();
    super.dispose();
  }

  void _setupAudioPlayer() {
    // Listen for when songs complete to play next song
    widget.backgroundPlayer.onPlayerComplete.listen((_) {
      _playNextSong();
    });
  }

  void _playNextSong() {
    if (_isPlaying) {
      _currentSongIndex = (_currentSongIndex + 1) % widget.backgroundSongs.length;
      widget.backgroundPlayer.play(AssetSource(widget.backgroundSongs[_currentSongIndex]));
    }
  }

  void _updateAudioFromSettings(SettingsLoaded settings) {
    // Update volume
    widget.backgroundPlayer.setVolume(settings.masterVolume);

    // Update audio service settings
    AudioService.updateSettings(
      soundEffectsEnabled: settings.soundEffectsEnabled,
      masterVolume: settings.masterVolume,
    );

    // Update animation service settings
    AnimationService.updateSettings(
      animationsEnabled: settings.animationsEnabled,
    );

    // Handle music toggle
    if (settings.musicEnabled && !_isPlaying) {
      // Start playing music
      _isPlaying = true;
      widget.backgroundPlayer.play(AssetSource(widget.backgroundSongs[_currentSongIndex]));
    } else if (!settings.musicEnabled && _isPlaying) {
      // Stop playing music
      _isPlaying = false;
      widget.backgroundPlayer.stop();
    } else if (!settings.musicEnabled && !_isPlaying) {
      // Ensure music stays stopped
      widget.backgroundPlayer.stop();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return BlocProvider.value(
      value: _settingsBloc,
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            _updateAudioFromSettings(state);
          }
        },
        child: const MaterialApp(
          home: Scaffold(body: HomeScreen()),
        ),
      ),
    );
  }

}

