import 'package:audioplayers/audioplayers.dart';

class MusicManager {
  static final MusicManager _instance = MusicManager._internal();
  factory MusicManager() => _instance;
  MusicManager._internal();

  AudioPlayer? _player;
  bool _isPlaying = false;

  Future<void> playMenuMusic() async {
  if (_isPlaying) return; // ya suena
  _player ??= AudioPlayer(playerId: 'menuMusic');
  await _player!.setReleaseMode(ReleaseMode.loop);

  if (_player!.state != PlayerState.playing) {
    await _player!.play(AssetSource('music/Boing.wav'));
  }

  _isPlaying = true;
}

  Future<void> pauseMusic() async {
    if (_player != null && _isPlaying) {
      await _player!.pause();
      _isPlaying = false;
    }
  }

  Future<void> resumeMusic() async {
    if (_player != null && !_isPlaying) {
      await _player!.resume();
      _isPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    if (_player != null) {
      await _player!.stop();
      _isPlaying = false;
    }
  }
}
