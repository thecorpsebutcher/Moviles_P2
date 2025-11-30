import 'package:flutter/material.dart';
import 'package:juego_flutter/screens/ranking_screen.dart';
import 'dart:async';
import '../scoreManager.dart';
import 'optionsMenu_screen.dart';
import '../audio_manager.dart';
import '../countdown_overlay.dart';


class GameScreen extends StatefulWidget {
  final Color playerColor;
  final Color backgroundColor;

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
    bouncePlayer = SoundEffect('sounds/ballBounce.wav');
    jumpPlayer = SoundEffect('sounds/jump.wav');
    deathPlayer = SoundEffect('sounds/death.wav');
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        velocityY += gravity;
        yPosition += velocityY;

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

        xPosition += velocityX;
        double maxWidth = MediaQuery.of(context).size.width - circleSize;

        if (xPosition <= 0) {
          xPosition = 0;
          velocityX = velocityX.abs();
          score++;
          playBounceSound();
        } else if (xPosition >= maxWidth) {
          xPosition = maxWidth;
          velocityX = -velocityX.abs();
          score++;
          playBounceSound();
        }
      });
    });
  }

  void pauseGame() {
    _timer?.cancel();
  }

 Future<void> resumeGameWithCountdown() async {
  int countdown = 3;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CountdownOverlay(
        countdownStart: countdown,
        onFinished: () {
          Navigator.of(context).pop(); // cerrar overlay
          velocityY = jump;            // aplicar salto
          playJumpSound();             // reproducir sonido de salto
          _startGame();                // reanudar juego
        },
      );
    },
  );
}



  void gameOver() async {
    _timer?.cancel();
    await ScoreManager.saveScore(score);
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
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                pauseGame();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OptionsMenuScreen(
                      fromGame: true,
                      onResume: () {
                        resumeGameWithCountdown();
                      },
                    ),
                  ),
                );
              },
            ),

          ],
        ),
        body: Stack(
          children: [
            Positioned(
              left: xPosition,
              top: yPosition,
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: widget.playerColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


