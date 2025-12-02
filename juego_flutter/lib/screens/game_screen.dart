import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../scoreManager.dart';
import '../audio_manager.dart';
import '../music_manager.dart';
import '../countdown_overlay.dart';
import '../screens/ranking_screen.dart';
import '../screens/optionsMenu_screen.dart';
import '../widgets/pincho.dart';

class GameScreen extends StatefulWidget {
  final Color playerColor;
  final Color backgroundColor;
  // final Color playerColor;
  // final Color backgroundColor;

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
  double ballScale = 1.0;
  double flashOpacity = 0.0;
  double circleSize = 50;
  List<TrailPoint> trail = [];
  late double screenWidth;
  late double screenHeight;
  late double slotHeight;
  late double pinchoHeight;
    late double pinchoWidth;
  double marginTop = 0;
  double marginBottom = 50;
  double scoreScale = 1.0;
  double scoreAlpha = 0.15;

  int numSlotsV = 5;

  late List<bool> pinchosIzq;
  late List<bool> pinchosDer;

  late Timer _timer;

  int score = 0;

  // Sonidos
  late SoundEffect bouncePlayer;
  late SoundEffect jumpPlayer;
  late SoundEffect deathPlayer;
  // late BackgroundMusic bgMusic;

  // Pincho widget cache
  late final String spikeWidget;

  @override
  void initState() {
    super.initState();

    MusicManager().pauseMusic(); // pausa la música del menú

    // Cargar imagen de pincho
    spikeWidget = 'assets/sprites/spike.png';

    // Inicializar sonidos
    bouncePlayer = SoundEffect('sounds/ballBounce.wav');
    jumpPlayer = SoundEffect('sounds/jump2.wav');
    deathPlayer = SoundEffect('sounds/death.wav');

    // Música en bucle
    // bgMusic = BackgroundMusic('music/Boing.wav');
    // bgMusic.playLoop();

    // Esperar primer frame para usar MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height - 150;


      pinchoHeight = 40;
      pinchoWidth = 40;
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
  setState(() {
    // Actualizar física de la bola
    velocityY += gravity;

    // Sub-steps para mejorar la detección de colisiones
    
    int steps = 4; // número de mini pasos por frame
    double stepX = velocityX / steps;
    double stepY = velocityY / steps;
 


    for (int s = 0; s < steps; s++) {
  xPosition += stepX;
  yPosition += stepY;

  // Rebote izquierdo
  if (xPosition <= 0 && velocityX < 0) {
    xPosition = 0;
    velocityX = velocityX.abs();
    score++;
    playBounceSound();
    animateScore();
    pinchosDer = resetSpikes(numSlotsV);
    pinchosIzq = emptySpikes(numSlotsV);
  } 
  // Rebote derecho
  else if (xPosition + circleSize >= screenWidth && velocityX > 0) {
    xPosition = screenWidth - circleSize;
    velocityX = -velocityX.abs();
    score++;
    playBounceSound();
    animateScore();
    pinchosIzq = resetSpikes(numSlotsV);
    pinchosDer = emptySpikes(numSlotsV);
  }
}

      // Detectar colisiones con pinchos
      double spikeThickness = 20;

      for (int i = 0; i < numSlotsV; i++) {
  double py = marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2;

  if (pinchosIzq[i] && tocaPincho(
        ballX: xPosition,
        ballY: yPosition,
        ballSize: circleSize,
        pinchoX: 0,           // coincide con el collider pintado
        pinchoY: py,          // coincide con el collider pintado
        pinchoWidth: pinchoWidth,
        pinchoHeight: pinchoHeight,
        padding: 5,           // margen permisivo
  )) {
    playDeathSound();
    gameOver();
    return;
  }
}
for (int i = 0; i < numSlotsV; i++) {
  double py = marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2;

  if (pinchosDer[i] && tocaPincho(
        ballX: xPosition,
        ballY: yPosition,
        ballSize: circleSize,
        pinchoX: screenWidth - pinchoWidth,  // coincide con el collider pintado
        pinchoY: py,                         // coincide con el collider pintado
        pinchoWidth: pinchoWidth,
        pinchoHeight: pinchoHeight,
        padding: 5,
  )) {
    playDeathSound();
    gameOver();
    return;
  }
}

      // Limites superior/inferior
      if (yPosition <= marginTop - circleSize / 2 ||
          yPosition + circleSize >= screenHeight + marginBottom) {
        playDeathSound();
        gameOver();
        return;
      }
    

    // Actualizar trail
    for (int i = 0; i < trail.length; i++) {
      trail[i].opacity -= 0.05;
      trail[i].scale -= 0.03;
    }
    trail.removeWhere((t) => t.opacity <= 0 || t.scale <= 0);
  });
});
  }

void animateScore() {
  setState(() {
    scoreScale = 2; // aumenta un 30% al tocar la pared
  });

  Future.delayed(const Duration(milliseconds: 50), () {
    if (!mounted) return;
    setState(() {
      scoreScale = 1.0; // vuelve al tamaño original
    });
  });
}

bool tocaPincho({
  required double ballX,
  required double ballY,
  required double ballSize,
  required double pinchoX,
  required double pinchoY,
  required double pinchoWidth,
  required double pinchoHeight,
  double padding = 5, // margen permisivo
}) {
  double radius = ballSize / 2;
  double centerX = ballX + radius;
  double centerY = ballY + radius;

  // Reducimos el área de colisión del pincho
  double closestX = centerX.clamp(pinchoX + padding, pinchoX + pinchoWidth - padding);
  double closestY = centerY.clamp(pinchoY + padding, pinchoY + pinchoHeight - padding);

  double dx = centerX - closestX;
  double dy = centerY - closestY;

  return (dx * dx + dy * dy) <= (radius * radius);
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

  // Reanudar música
  // await MusicManager().playMenuMusic(); // <- aseguramos que arranque en menú

  // Navegar a RankingScreen sin reemplazar rutas anteriores
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RankingScreen(lastScore: score)),
  );
}


 void _jumpUp() {
  velocityY = jump;
  playJumpSound();

  // Añadir un punto al trail
  trail.add(TrailPoint(
    x: xPosition,
    y: yPosition,
    opacity: 0.6,
    scale: 1.0,
  ));

  // Animación squash + flash (como ya tienes)
  setState(() {
    ballScale = 0.85;
    flashOpacity = 0.35;
  });

  Future.delayed(const Duration(milliseconds: 120), () {
    if (!mounted) return;
    setState(() => ballScale = 1.0);
  });

  Future.delayed(const Duration(milliseconds: 90), () {
    if (!mounted) return;
    setState(() => flashOpacity = 0.0);
  });
}

  @override
void dispose() {
  _timer.cancel();

  // bgMusic.dispose();
  
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
             // Score
            Center(
              child: AnimatedScale(
                scale: scoreScale,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: Opacity(
                  opacity: scoreAlpha,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      '$score',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 600, // tamaño enorme
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ...trail.map((t) {
            return Positioned(
              left: t.x,
              top: t.y,
              child: Transform.scale(
                scale: t.scale,
                child: Opacity(
                  opacity: t.opacity,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.playerColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          
            Positioned(
              left: xPosition,
              top: yPosition,
              child: AnimatedScale(
                scale: ballScale,
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.playerColor,
                    ),
                    ),

                              AnimatedOpacity(
                    opacity: flashOpacity,              // ← se anima solo el flash
                    duration: const Duration(milliseconds: 90),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]
                
                
                  ),
                ),
              ),
      

               // Pinchos y colliders
              for (int i = 0; i < numSlotsV; i++)
                if (pinchosIzq[i])
                  // Pincho visual
                  Pincho(
                    x: 0,
                    y: marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2,
                    width:pinchoWidth ,
                    height: pinchoHeight,
                    rotation: math.pi / 2,
                    assetPath: spikeWidget,
                  ),
              /*
              for (int i = 0; i < numSlotsV; i++)
                if (pinchosIzq[i])
                  // Collider visualizado
                  
                  Positioned(
                    left: 0,
                    top: marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2,
                    child: Container(
                      width: pinchoWidth,
                      height: pinchoHeight,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3), // color semi-transparente
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                */

              for (int i = 0; i < numSlotsV; i++)
                if (pinchosDer[i])
                  Pincho(
                    x: screenWidth - pinchoWidth,
                    y: marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2,
                    width: pinchoWidth,
                    height: pinchoHeight,
                    rotation: -math.pi / 2,
                    assetPath: spikeWidget,
                  ),

              /*
              for (int i = 0; i < numSlotsV; i++)
                if (pinchosDer[i])
                  Positioned(
                    left: screenWidth - pinchoWidth,
                    top: marginBottom + i * slotHeight + (slotHeight - pinchoHeight)/2,
                    child: Container(
                      width: pinchoWidth,
                      height: pinchoHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        border: Border.all(color: Colors.blue, width: 1),
                      ),
                    ),
                  ),
                  */
           
          ],
        ),
      ),
    );
  }
}

class TrailPoint {
  final double x;
  final double y;
  double opacity;
  double scale;

  TrailPoint({
    required this.x,
    required this.y,
    this.opacity = 1.0,
    this.scale = 1.0,
  });
}


