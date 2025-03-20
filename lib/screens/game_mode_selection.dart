import 'package:flutter/material.dart';
import 'game_screen.dart';

class GameModeSelectionScreen extends StatelessWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tic - Tac - Toe", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _selectDifficulty(context);
              },
              child: const Text("Play with Friend"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDifficulty(context);
              },
              child: const Text("Play with AI"),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDifficulty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.cyan.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Player Level Type", style: TextStyle(fontSize: 20,)),
              const SizedBox(height: 20),
              _difficultyButton(context, "Easy"),
              SizedBox(height: 10),
              _difficultyButton(context, "Medium"),
              SizedBox(height: 10),
              _difficultyButton(context, "Hard"),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyButton(BuildContext context, String level) {
    int gridSize = (level == "Easy") ? 3 : (level == "Medium") ? 4 : 5;

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              isMultiplayer: false,
              gridSize: gridSize,
              difficulty: level,
            ),
          ),
        );
      },
      child: Text(level),
    );
  }
}
