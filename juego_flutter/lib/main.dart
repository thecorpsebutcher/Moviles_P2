import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Juego Flutter',
      home: MenuScreen(),
    );
  }
}

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
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),

            // Botón JUGAR
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

            // Botón SALIR
            ElevatedButton(
              onPressed: () {
                exit(0); // Cierra la app
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Salir"),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Text(
          "Pantalla de Juego",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
