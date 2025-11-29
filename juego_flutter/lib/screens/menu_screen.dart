import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'dart:io';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mi Juego",
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text("Jugar"),
            ),
            SizedBox(height: 20),
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