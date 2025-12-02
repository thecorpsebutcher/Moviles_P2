import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  double _volume = 0.5;
  double get volume => _volume;

  /// Cargar volumen desde SharedPreferences
  Future<void> loadVolume() async {
    final prefs = await SharedPreferences.getInstance();
    _volume = prefs.getDouble('volume') ?? 0.5;
  }

  /// Guardar volumen en SharedPreferences
  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', _volume);
  }
}

// -------------------- Música de fondo --------------------
class BackgroundMusic {
  final String assetPath;
  late final AudioPlayer _player;
  bool _isPlaying = false;

  BackgroundMusic(this.assetPath) {
    _player = AudioPlayer();
  }

  /// Reproducir música en bucle
  Future<void> playLoop() async {
    if (_isPlaying) return; // Evitar reiniciar si ya está sonando
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setSource(AssetSource(assetPath));
    await _player.setVolume(AudioManager().volume);
    await _player.resume();
    _isPlaying = true;
  }

  /// Pausar música
  Future<void> pause() async {
    if (!_isPlaying) return;
    await _player.pause();
    _isPlaying = false;
  }

  /// Detener música
  Future<void> stop() async {
    if (!_isPlaying) return;
    await _player.stop();
    _isPlaying = false;
  }

  /// Liberar recursos
  void dispose() {
    _player.dispose();
  }
}

// -------------------- Efectos de sonido --------------------
class SoundEffect {
  final String assetPath;

  SoundEffect(this.assetPath);

  /// Reproducir efecto de sonido
  Future<void> play() async {
    final player = AudioPlayer(); // Player temporal
    await player.setVolume(AudioManager().volume);
    await player.play(AssetSource(assetPath));

    // Liberar recursos automáticamente cuando termine
    player.onPlayerComplete.listen((_) {
      player.dispose();
    });
  }
}
