import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../scoreManager.dart';
import '../audio_manager.dart';
import '../countdown_overlay.dart';
import '../screens/ranking_screen.dart';
import '../screens/optionsMenu_screen.dart';
import '../widgets/pincho.dart';

class GameScreen extends StatefulWidget {
  final Color playerColor;
  final Color backgroundColor;
  final Color playerColor;
  final Color backgroundColor;

  GameScreen({required this.playerColor, required this.backgroundColor});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double xPosition = 0;
  double yPosition = 0;
  double velocityX = -3;
  double velocityY = 0;
  double gravity = 0.5;
  double jump = -10;

  double circleSize = 50;

  late double screenWidth;
  late double screenHeight;
  late double slotHeight;
  late double pinchoHeight;
  double marginTop = 50;
  double marginBottom = 50;

  int numSlotsV = 5;

  late List<bool> pinchosIzq;
  late List<bool> pinchosDer;

  late Timer _timer;

  int score = 0;

  // Sonidos
  late SoundEffect bouncePlayer;
  late SoundEffect jumpPlayer;
  late SoundEffect deathPlayer;

  // Pincho widget cache
  late final String spikeWidget;

  @override
  void initState() {
    super.initState();

    // Cargar imagen de pincho
    spikeWidget = 'assets/sprites/spike.png';

    bouncePlayer = SoundEffect('sounds/ballBounce.wav');
    jumpPlayer = SoundEffect('sounds/jump.wav');
    deathPlayer = SoundEffect('sounds/death.wav');

    // Esperar primer frame para usar MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height - 150;


      pinchoHeight = 20;
      slotHeight = (screenHeight - marginTop - marginBottom) / numSlotsV;

      // Posición inicial centrada
      xPosition = screenWidth / 2 - circleSize / 2;
      yPosition = screenHeight / 2 - circleSize / 2;

      // Pinchos iniciales
      pinchosIzq = emptySpikes(numSlotsV);
      pinchosDer = emptySpikes(numSlotsV);

      _startGame();
    });
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      // Actualizar física de la bola
      velocityY += gravity;
      yPosition += velocityY;
      xPosition += velocityX;

      // Rebote izquierdo/derecho
      if (xPosition <= 0) {
        xPosition = 0;
        velocityX = velocityX.abs();
        score++;
        playBounceSound();
        pinchosDer = resetSpikes(numSlotsV);
        pinchosIzq = emptySpikes(numSlotsV);
      } else if (xPosition + circleSize >= screenWidth) {
        xPosition = screenWidth - circleSize;
        velocityX = -velocityX.abs();
        score++;
        playBounceSound();
        pinchosIzq = resetSpikes(numSlotsV);
        pinchosDer = emptySpikes(numSlotsV);
      }

      // Detectar colisiones solo con pinchos
      
      setState(() {}); // Solo actualiza bola y score
      for (int i = 0; i < numSlotsV; i++) {
        // izquierda
        if (pinchosIzq[i] &&
            tocaPincho(
              pinchoHeight,
              marginTop + i * slotHeight,
               pinchoHeight,
              slotHeight,
              xPosition,
              yPosition,
              circleSize,
            )) {
          playDeathSound();
          gameOver();
        }
        // derecha
        if (pinchosDer[i] &&
            tocaPincho(
              screenWidth - 70 + pinchoHeight,
              marginTop + i * slotHeight,
               pinchoHeight,
              slotHeight,
              xPosition,
              yPosition,
              circleSize,
            )) {
          playDeathSound();
          gameOver();
        }
      }
      if(yPosition <=  0)
      {
          playDeathSound();
          gameOver();
      }
      if(yPosition >= (slotHeight*numSlotsV)+slotHeight)
      {
        playDeathSound();
        gameOver();
      }
    });
  }

  bool tocaPincho(double px, double py, double pw, double ph, double bx, double by, double bs){
      // Centro de la bola
  double cx = bx + bs / 2;
  double cy = by + bs / 2;

  // Limites del pincho
  double left = px;
  double right = px + pw;
  double top = py;
  double bottom = py + ph;

  // Revisar si el centro de la bola está dentro del pincho (puedes añadir un padding)
  const double padding = 3;
  return cx > left + padding && cx < right - padding && cy > top + padding && cy < bottom - padding;
  
  }

  List<bool> emptySpikes(int n) => List.generate(n, (_) => false);

  List<bool> resetSpikes(int n) {
  math.Random rand = math.Random();

  // Si n es demasiado pequeño, simplemente devolvemos todo vacío
  if (n <= 1) {
    return List<bool>.filled(n, false);
  }

  int minSpikes = 2;
  int maxSpikes = 3;

  // No se pueden poner más pinchos que espacios disponibles
  int maxPossible = n;

  // Elegimos cuántos pinchos habrá (si n es pequeño, se reduce automáticamente)
  int totalSpikes = rand.nextInt(maxSpikes - minSpikes + 1) + minSpikes;
  totalSpikes = totalSpikes.clamp(0, maxPossible);

  // Lista inicial (todos vacíos)
  List<bool> spikes = List<bool>.filled(n, false);

  // Creamos una lista con todos los índices disponibles
  List<int> allSlots = List.generate(n, (i) => i);

  // Mezclamos para elegir aleatoriamente
  allSlots.shuffle(rand);

  // Activamos los primeros `totalSpikes` slots
  for (int i = 0; i < totalSpikes; i++) {
    spikes[allSlots[i]] = true;
  }

  return spikes;
  }

  void playBounceSound() => bouncePlayer.play();
  void playJumpSound() => jumpPlayer.play();
  void playDeathSound() => deathPlayer.play();

  void gameOver() async {
    _timer?.cancel(); 
    await ScoreManager.saveScore(score); 
    Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => RankingScreen()), );
  }

  void _jumpUp() {
    velocityY = jump;
    playJumpSound();
  }

  @override
  void dispose() {
    _timer.cancel();
    bouncePlayer.dispose();
    jumpPlayer.dispose();
    deathPlayer.dispose();
    super.dispose();
  }

  void pauseGame() { _timer?.cancel(); }

  Future<void> resumeGameWithCountdown() async 
  { int countdown = 3;
   await showDialog(
     context: context,
      barrierDismissible: false,
       builder: (context) {
         return CountdownOverlay(
           countdownStart: 
           countdown,
            onFinished: () {
               Navigator.of(context).pop(); // cerrar overlay 
               velocityY = jump; // aplicar salto
                playJumpSound(); // reproducir sonido de salto 
                _startGame(); // reanudar juego 
                },
                 );
                  },
                   );
                    }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _jumpUp,
     child: Scaffold( backgroundColor: widget.backgroundColor, 
     appBar: AppBar( backgroundColor:
      Colors.transparent,
       elevation: 0,
        actions: [
           IconButton(
             icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () { 
                pauseGame();
                 Navigator.push( context, MaterialPageRoute( builder: (context) => OptionsMenuScreen( fromGame: true,
                  onResume: () { resumeGameWithCountdown(); }, ), ), ); }, ), ], ),
        body: Stack(
          children: [
            // Bola
            Positioned(
              left: xPosition,
              top: yPosition,
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: widget.playerColor,
                  color: widget.playerColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Pinchos IZQ
            for (int i = 0; i < numSlotsV; i++)
              if (pinchosIzq[i])
                Pincho(
                  x: -50,
                  y: marginBottom + i * slotHeight,
                  width: slotHeight,
                  height: pinchoHeight,
                  rotation: math.pi / 2,
                  assetPath: spikeWidget,
                ),

            // Pinchos DER
            for (int i = 0; i < numSlotsV; i++)
              if (pinchosDer[i])
                Pincho(
                  x: screenWidth-70,
                  y: marginBottom + i * slotHeight,
                  width: slotHeight,
                  height: pinchoHeight,
                  rotation: -math.pi / 2,
                  assetPath: spikeWidget,
                ),

            // Score
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '$score',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
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


