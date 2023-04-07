import 'dart:convert';
import 'package:http/http.dart' as http;

import 'game.dart';

class GameService {
  static const baseUrl = 'https://www.mmobomb.com/api1/games';

  static Future<List<Game>> getGames(String? platform) async {
    final url = platform != null ? '$baseUrl?platform=$platform' : baseUrl;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }
}
