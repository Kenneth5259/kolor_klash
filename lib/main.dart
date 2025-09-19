import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kolor_klash/screens/home_screen/home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final backgroundPlayer = AudioPlayer();
  final backgroundSongs = [
    'music/background/inspirational-background-112290.mp3',
    'music/background/that-background-ambient-114376.mp3',
    'music/background/upbeat-day-190084.mp3'
  ];


  runApp(MyApp(backgroundPlayer: backgroundPlayer, backgroundSongs: backgroundSongs));
}

class MyApp extends StatelessWidget {
  final AudioPlayer backgroundPlayer;
  final List<String> backgroundSongs;

  const MyApp({super.key, required this.backgroundPlayer, required this.backgroundSongs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    playList();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return const MaterialApp(
        home: Scaffold(body: HomeScreen(),)
    );
  }

  void playList() async {
    backgroundPlayer.play(AssetSource(backgroundSongs[0]));
    int i = 1;

    backgroundPlayer.onPlayerComplete.listen((_) {
      if(i < backgroundSongs.length) {
        backgroundPlayer.play(AssetSource(backgroundSongs[i]));
        i++;
      } else {
        i = 1;
        backgroundPlayer.play(AssetSource(backgroundSongs[0]));
      }
    });
  }
}

