import 'package:flutter/material.dart';
import 'game_list_screen.dart';

void main(){
  runApp(const GameListApp());
}

class GameListApp extends StatelessWidget {
  const GameListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // title: 'Game List App',
      home: GameListScreen(),
    );
  }
}