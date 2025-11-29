import 'package:flutter/material.dart';
import '../scoreManager.dart';
import 'menu_screen.dart';

class RankingScreen extends StatefulWidget {
  final int? lastScore;

  RankingScreen({this.lastScore});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  void loadScores() async {
    scores = await ScoreManager.getScores();
    setState(() {});
  }

  Widget _buildMedalIcon(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.emoji_events, color: Colors.amber, size: 30);
      case 1:
        return Icon(Icons.emoji_events, color: Colors.grey, size: 28);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.brown, size: 26);
      default:
        return SizedBox(width: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo degradado
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Ranking",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                  shadows: [
                    Shadow(
                        blurRadius: 5,
                        color: Colors.black45,
                        offset: Offset(2, 2)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    bool isLast =
                        widget.lastScore != null && scores[index] == widget.lastScore;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: isLast
                          ? Colors.yellow.shade700
                          : Colors.white.withOpacity(0.1),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: _buildMedalIcon(index),
                        title: Text(
                          "Puntuación: ${scores[index]}",
                          style: TextStyle(
                            color: isLast ? Colors.black : Colors.white,
                            fontSize: 22,
                            fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          "#${index + 1}",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
