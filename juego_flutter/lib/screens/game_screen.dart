import 'package:flutter/material.dart';
import 'package:juego_flutter/screens/ranking_screen.dart';
import 'dart:async';
import '../scoreManager.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundEffect {
  final String assetPath;
  final double volume;
  final List<AudioPlayer> pool = [];

  SoundEffect(this.assetPath, {this.volume = 1.0});

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
      volume: volume,
    );
  }

  void dispose() {
    for (var p in pool) {
      p.dispose();
    }
  }
}

class GameScreen extends StatefulWidget {
  final Color playerColor;       // color del jugador
  final Color backgroundColor;   // color de fondo

  GameScreen({
    required this.playerColor,
    required this.backgroundColor,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double yPosition = 0;       
  double xPosition = 0;       
  double velocityY = 0;      
  double velocityX = -3;      
  double gravity = 0.5;
  double jump = -10;

  double circleSize = 50;
  Timer? _timer;

  int score = 0;

  // SONIDOS
  late SoundEffect bouncePlayer;
  late SoundEffect jumpPlayer;
  late SoundEffect deathPlayer;

  @override
  void initState() {
    super.initState();

    // Creamos AudioPlayers individuales
    bouncePlayer = SoundEffect('sounds/ballBounce.wav', volume: 0.7);
    jumpPlayer = SoundEffect('sounds/jump.wav', volume: 0.3);
    deathPlayer = SoundEffect('sounds/death.wav');

    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        // --- Movimiento vertical ---
        velocityY += gravity;
        yPosition += velocityY;

        // Limites verticales
        double maxHeight = MediaQuery.of(context).size.height - circleSize;
        if (yPosition > maxHeight) {
          yPosition = maxHeight;
          velocityY = 0;
          playDeathSound();
          gameOver();
        }
        if (yPosition < 0) {
          yPosition = 0;
          velocityY = 0;
          playDeathSound();
          gameOver();
        }

        // --- Movimiento horizontal ---
        xPosition += velocityX;
        double maxWidth = MediaQuery.of(context).size.width - circleSize;

        if (xPosition <= 0) {
          xPosition = 0;
          velocityX = velocityX.abs(); // cambiar a derecha
          score++;
          playBounceSound();
        } else if (xPosition >= maxWidth) {
          xPosition = maxWidth;
          velocityX = -velocityX.abs(); // cambiar a izquierda
          score++;
          playBounceSound();
        }
      });
    });
  }

  void gameOver() async {
    _timer?.cancel();

    // Guardar la puntuación actual
    await ScoreManager.saveScore(score);

    // Ir directamente a la pantalla de ranking
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RankingScreen()),
    );
  }

  void _jumpUp() {
    setState(() {
      velocityY = jump;
      playJumpSound();
    });
  }

  void playBounceSound() => bouncePlayer.play();
  void playJumpSound() => jumpPlayer.play();
  void playDeathSound() => deathPlayer.play();

  @override
  void dispose() {
    _timer?.cancel();
    bouncePlayer.dispose();
    jumpPlayer.dispose();
    deathPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _jumpUp,
      child: Scaffold(
        backgroundColor: widget.backgroundColor, // usa el color pasado
        body: Stack(
          children: [
            // Jugador
            Positioned(
              left: xPosition,
              top: yPosition,
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: widget.playerColor, // usa el color pasado
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Score arriba
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  '$score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}