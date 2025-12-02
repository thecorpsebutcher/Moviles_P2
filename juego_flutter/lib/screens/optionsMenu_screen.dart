import 'package:flutter/material.dart';
import '../audio_manager.dart';
import 'menu_screen.dart';

class OptionsMenuScreen extends StatefulWidget {
  final VoidCallback? onResume;
  final bool fromGame;

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
                fontFamily: 'PressStart',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF8E1),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Ajustes del juego",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 16,
                color: Color(0xFFFFF8E1),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Volumen",
                        style: TextStyle(
                          fontFamily: 'PressStart',
                          fontSize: 18,
                          color: Color(0xFFFFF8E1),
                        ),
                      ),
                      Text(
                        "${(_volume * 100).round()}%",
                        style: TextStyle(
                          fontFamily: 'PressStart',
                          fontSize: 18,
                          color: Color(0xFFFFF8E1),
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
                  if (widget.fromGame)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.onResume != null) widget.onResume!();
                      },
                      child: Text(
                        "Seguir jugando",
                        style: TextStyle(
                          fontFamily: 'PressStart',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFF8E1),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                        fontFamily: 'PressStart',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFF8E1),
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
