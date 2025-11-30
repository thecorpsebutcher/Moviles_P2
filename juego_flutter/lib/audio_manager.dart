import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  double _volume = 0.5;

  double get volume => _volume;

  Future<void> loadVolume() async {
    final prefs = await SharedPreferences.getInstance();
    _volume = prefs.getDouble('volume') ?? 0.5;
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
  }
}

class SoundEffect {
  final String assetPath;
  final List<AudioPlayer> pool = [];

  SoundEffect(this.assetPath);

  Future play() async {
    AudioPlayer freePlayer = pool.firstWhere(
      (p) => p.state != PlayerState.playing,
      orElse: () {
        final newPlayer = AudioPlayer();
        pool.add(newPlayer);
        return newPlayer;
      },
    );

    await freePlayer.play(
      AssetSource(assetPath),
      volume: AudioManager().volume, // usa volumen global
    );
  }

  void dispose() {
    for (var p in pool) {
      p.dispose();
    }
  }
}