// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'game.dart';
import 'game_service.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _platformFilter;
  List<Game> _games = [];

  List<Game> _filteredGames = [];
  bool _isLoading = false;

  get floatingActionButton => null;

  @override
  void initState() {
    super.initState();
    _fetchGames();
    _searchController.addListener(() {
      _onSearchTextChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchGames() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final games = await GameService.getGames(_platformFilter);
      setState(() {
        _games = games;
        _filteredGames = _games;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onPlatformFilterChanged(String? value) {
    setState(() {
      _platformFilter = value;
    });
    _fetchGames();
  }

  Future<void> _onSearchTextChanged(String value) async {
    setState(() {
      _games = _filteredGames
          .where(
              (game) => game.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });

    if (value.isEmpty) {
      final games = await GameService.getGames(_platformFilter);
      setState(() {
        _games = games;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GAMEZO',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
       
        backgroundColor: const Color.fromARGB(255, 0, 4, 5),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: const InputDecoration(
                hintText: 'Search by Title',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Platforms',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _platformFilter,
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: 'browser', child: Text('Web Browser')),
                DropdownMenuItem(value: 'pc', child: Text('PC')),
              ],
              onChanged: _onPlatformFilterChanged,
            ),
          ),
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
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(game.title),
                        subtitle: Text(
                            '${game.genre}    ${game.platform}   ${game.release_date}'),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(9.0)),
        ),
        onPressed: null,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 20.0,
        child: Text('Vivahit', style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),)
      ),
    );
  }
}
