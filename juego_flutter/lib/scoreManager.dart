import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const String _key = 'scores';

  // Guardar un score
  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedScores = prefs.getStringList(_key) ?? [];

    // Convertir a int
    List<int> scores = storedScores.map((s) => int.tryParse(s) ?? 0).toList();

    // Añadir el nuevo score
    scores.add(score);

    // Ordenar de mayor a menor
    scores.sort((b, a) => a.compareTo(b));

    // Mantener solo los 10 mejores
    if (scores.length > 10) {
      scores = scores.sublist(0, 10);
    }

    // Guardar como String
    List<String> stringScores = scores.map((s) => s.toString()).toList();
    await prefs.setStringList(_key, stringScores);
  }

  // Obtener los scores guardados
  static Future<List<int>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedScores = prefs.getStringList(_key) ?? [];
    List<int> scores = storedScores.map((s) => int.tryParse(s) ?? 0).toList();

    // Ordenar de mayor a menor (por si acaso)
    scores.sort((b, a) => a.compareTo(b));

    return scores;
  }
}
