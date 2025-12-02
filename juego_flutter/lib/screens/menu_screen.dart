import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'dart:io';
import 'ranking_screen.dart';
import 'optionsMenu_screen.dart';
import '../music_manager.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;
  final List<Color> playerColors = [
    const Color.fromARGB(255, 218, 123, 213),
    const Color.fromARGB(255, 255, 220, 105),
    const Color.fromARGB(255, 83, 255, 189)
  ];

  @override
  void initState() {
    super.initState();
    MusicManager().playMenuMusic(); // inicia música en bucle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PELOTUDA",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF8E1),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(playerColors.length, (index) {
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: playerColors[index],
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(width: 5, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                MusicManager().pauseMusic(); // pausa música en el juego
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      playerColor: playerColors[selectedIndex],
                      backgroundColor: Colors.blueGrey[900]!,
                    ),
                  ),
                );
              },
              child: Text(
                "Jugar",
                style: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 20,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RankingScreen()),
                );
              },
              child: Text(
                "Ranking",
                style: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 20,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OptionsMenuScreen()),
                );
              },
              child: Text(
                "Opciones",
                style: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFF8E1),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => exit(0),
              child: Text(
                "Salir",
                style: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFF8E1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
