import 'package:flutter/material.dart';
import '../scoreManager.dart';
import '../music_manager.dart';
import 'menu_screen.dart';

class RankingScreen extends StatefulWidget {
  final int? lastScore;

  RankingScreen({this.lastScore});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    MusicManager().playMenuMusic();
    loadScores();
  }

  void loadScores() async {
    scores = await ScoreManager.getScores();
    setState(() {});
  }

  Widget _podiumColumn(int index, int score, Color color, double height) {
    Icon? icon;
    switch (index) {
      case 0:
        icon = Icon(Icons.emoji_events, color: Colors.amber.shade600, size: 28);
        break;
      case 1:
        icon = Icon(Icons.emoji_events, color: Colors.grey.shade400, size: 26);
        break;
      case 2:
        icon = Icon(Icons.emoji_events, color: Colors.brown.shade400, size: 24);
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (icon != null) icon,
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: 70,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "$score",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium() {
    int first = scores.isNotEmpty ? scores[0] : 0;
    int second = scores.length > 1 ? scores[1] : 0;
    int third = scores.length > 2 ? scores[2] : 0;

    double baseHeight = 120;
    double firstHeight = baseHeight.toDouble();
    double secondHeight = baseHeight * 0.8;
    double thirdHeight = baseHeight * 0.6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _podiumColumn(1, second, Colors.green.shade200, secondHeight),
        SizedBox(width: 20),
        _podiumColumn(0, first, Colors.green.shade400, firstHeight),
        SizedBox(width: 20),
        _podiumColumn(2, third, Colors.green.shade100, thirdHeight),
      ],
    );
  }

  Widget _buildScoreList() {
    List<int> remainingScores = scores.length > 3 ? scores.sublist(3) : [];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: remainingScores.length,
      itemBuilder: (context, index) {
        bool isLast = widget.lastScore != null &&
            remainingScores[index] == widget.lastScore;

        return AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isLast ? Colors.amber.shade400 : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: isLast ? 10 : 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.star, color: Colors.yellow.shade600),
            title: Text(
              "Puntuación: ${remainingScores[index]}",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                fontSize: 18,
                color: Color(0xFFFFF8E1),
              ),
            ),
            trailing: Text(
              "#${index + 4}",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFFFF8E1),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Ranking",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFF8E1),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tus mejores puntuaciones",
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 16,
                color: Color(0xFFFFF8E1),
              ),
            ),
            SizedBox(height: 30),
            _buildPodium(),
            SizedBox(height: 30),
            Expanded(child: _buildScoreList()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                      (route) => false);
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
            ),
          ],
        ),
      ),
    );
  }
}
