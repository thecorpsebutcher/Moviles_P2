import 'package:flutter/material.dart';
import '../audio_manager.dart';
import 'menu_screen.dart';

class OptionsMenuScreen extends StatefulWidget {
  final VoidCallback? onResume; // callback para reanudar el juego
  final bool fromGame; // indica si viene desde GameScreen

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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Opciones",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF8E1), // blanco hueso
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Ajustes del juego",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFFF8E1), // blanco hueso
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  // Control de volumen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Volumen",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFF8E1), // blanco hueso
                        ),
                      ),
                      Text(
                        "${(_volume * 100).round()}%",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFF8E1), // blanco hueso
                        ),
                      ),
                    ],
                  ),
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
                  SizedBox(height: 30),
                  // Botón "Seguir jugando" solo si viene del juego
                  if (widget.fromGame)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // cerrar menú
                        if (widget.onResume != null) widget.onResume!();
                      },
                      child: Text(
                        "Seguir jugando",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFF8E1), // blanco hueso
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Botón "Volver al menú"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Volver al Menú",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFF8E1), // blanco hueso
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
