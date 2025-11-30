import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'dart:io';
import 'ranking_screen.dart';
import 'optionsMenu_screen.dart';


class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0; // índice del color seleccionado
  final List<Color> playerColors = [const Color.fromARGB(255, 218, 123, 213), const Color.fromARGB(255, 255, 220, 105), const Color.fromARGB(255, 83, 255, 189)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "El jueguillo de la bolilla que rebotea",
              style: TextStyle(
                  color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),

            // Botones de color
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

            // Botón jugar
            ElevatedButton(
              onPressed: () {
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
              child: Text("Jugar"),
            ),
            SizedBox(height: 20),

            // Botón ranking
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RankingScreen(),
                  ),
                );
              },
              child: Text("Ranking"),
            ),
            SizedBox(height: 20),

            //Botón opciones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OptionsMenuScreen()),
                );
              },
              child: const Text('Opciones'),
            ),

            const SizedBox(height: 20),

            // Botón salir
            ElevatedButton(
              onPressed: () => exit(0),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Salir"),
            ),
          ],
        ),
      ),
    );
  }
}