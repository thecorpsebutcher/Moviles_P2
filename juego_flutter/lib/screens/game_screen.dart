import 'package:flutter/material.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
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
        }
        if (yPosition < 0) {
          yPosition = 0;
          velocityY = 0;
        }

        // --- Movimiento horizontal ---
        xPosition += velocityX;
        double maxWidth = MediaQuery.of(context).size.width - circleSize;

        if (xPosition <= 0) {
          xPosition = 0;
          velocityX = velocityX.abs(); // cambiar a derecha
          score++;
        } else if (xPosition >= maxWidth) {
          xPosition = maxWidth;
          velocityX = -velocityX.abs(); // cambiar a izquierda
          score++;
        }
      });
    });
  }

  void _jumpUp() {
    setState(() {
      velocityY = jump;
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