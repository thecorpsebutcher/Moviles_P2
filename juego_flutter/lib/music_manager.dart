import 'package:audioplayers/audioplayers.dart';

class MusicManager {
  static final MusicManager _instance = MusicManager._internal();
  factory MusicManager() => _instance;
  MusicManager._internal();

  AudioPlayer? _player;
  bool _isPlaying = false;

  /// Reproducir música del menú en bucle
  Future<void> playMenuMusic() async {
  if (_isPlaying) return; // ya suena
  _player ??= AudioPlayer(playerId: 'menuMusic');
  await _player!.setReleaseMode(ReleaseMode.loop);

  if (_player!.state != PlayerState.playing) {
    await _player!.play(AssetSource('music/Boing.wav'));
  }

  _isPlaying = true;
}



  /// Pausar música (por ejemplo, al iniciar el juego)
  Future<void> pauseMusic() async {
    if (_player != null && _isPlaying) {
      await _player!.pause();
      _isPlaying = false;
    }
  }

  /// Reanudar música (por ejemplo, al morir y volver al menú)
  Future<void> resumeMusic() async {
    if (_player != null && !_isPlaying) {
      await _player!.resume();
      _isPlaying = true;
    }
  }

  /// Detener música completamente (opcional)
  Future<void> stopMusic() async {
    if (_player != null) {
      await _player!.stop();
      _isPlaying = false;
    }
  }
}
