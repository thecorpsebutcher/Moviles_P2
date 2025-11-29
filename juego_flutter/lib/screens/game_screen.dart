import 'package:flutter/material.dart';
import '../widgets/player.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double yPosition = 0;
  double velocity = 0;
  double gravity = 0.5;
  double jump = -10;
  late Player player;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    player = Player();
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        velocity += gravity;
        yPosition += velocity;

        double maxHeight = MediaQuery.of(context).size.height - 50;
        if (yPosition > maxHeight) {
          yPosition = maxHeight;
          velocity = 0;
        }
        if (yPosition < 0) {
          yPosition = 0;
          velocity = 0;
        }
      });
    });
  }

  void _jumpUp() {
    setState(() {
      velocity = jump;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _jumpUp,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 25,
              top: yPosition,
              child: player,
            ),
          ],
        ),
      ),
    );
  }
}