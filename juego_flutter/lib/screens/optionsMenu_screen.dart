import 'package:flutter/material.dart';
import '../audio_manager.dart';
import 'menu_screen.dart';

class OptionsMenuScreen extends StatefulWidget {
  final VoidCallback? onResume;   // callback para reanudar el juego
  final bool fromGame;            // indica si viene desde GameScreen

  const OptionsMenuScreen({Key? key, this.onResume, this.fromGame = false}) : super(key: key);

  @override
  State<OptionsMenuScreen> createState() => _OptionsMenuScreenState();
}

class _OptionsMenuScreenState extends State<OptionsMenuScreen> {
  double _volume = AudioManager().volume;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Opciones',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              const Text('Volumen', style: TextStyle(fontSize: 18, color: Colors.white)),
              Slider(
                value: _volume,
                min: 0,
                max: 1,
                divisions: 10,
                label: (_volume * 100).round().toString(),
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                    AudioManager().setVolume(value);
                  });
                },
              ),
              const SizedBox(height: 40),

              // Solo mostrar si viene desde GameScreen
              if (widget.fromGame)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // cerrar menú
                    if (widget.onResume != null) widget.onResume!();
                  },
                  child: const Text('Seguir jugando'),
                ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Volver al menú'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
