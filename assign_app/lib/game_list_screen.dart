import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'game.dart';
import 'game_service.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  List<Game> _games = [];
  bool _isLoading = false;
  @override
 void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final games = await GameService.getGames(null);
      setState(() {
        _games = games;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const   Text('GAMING WORLD', style: TextStyle(color: Color.fromARGB(255, 211, 11, 11)) ),
        
        backgroundColor: const Color.fromARGB(255, 32, 221, 228),
      ),
      body: Column(
        children: [
          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _games.length,
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: game.thumbnailUrl,
                          width: 60,
                          height: 60,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        title: Text(game.title),
                        subtitle: Text('${game.genre}    ${game.platform}   ${game.release_date}'),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
