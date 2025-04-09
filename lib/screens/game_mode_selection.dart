import 'package:flutter/material.dart';
import 'game_screen.dart';

class GameModeSelectionScreen extends StatelessWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        centerTitle: true,
        title: Text("Tic - Tac - Toe", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),
      ),

      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _selectFriendMode(context);
              },
              child: const Text("Play with Friend", style: TextStyle(color: Colors.white, fontSize: 18),),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectDifficulty(context);
              },
              child: const Text("Play with AI", style: TextStyle(color: Colors.white, fontSize: 18),),
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
            color: Colors.cyan.shade900,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
            // gradient: LinearGradient(
            //   colors: [Colors.cyan.shade700, Colors.black],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Player Level Type", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _difficultyButton(context, "Easy", isMultiplayer: false),
              SizedBox(height: 10),
              _difficultyButton(context, "Medium", isMultiplayer: false),
              SizedBox(height: 10),
              _difficultyButton(context, "Hard", isMultiplayer: false),
            ],
          ),
        );
      },
    );
  }

  void _selectFriendMode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.cyan.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Player Level Type", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _difficultyButton(context, "Easy", isMultiplayer: true),
              SizedBox(height: 10),
              _difficultyButton(context, "Medium", isMultiplayer: true),
              SizedBox(height: 10),
              _difficultyButton(context, "Hard", isMultiplayer: true),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyButton(BuildContext context, String level, {required bool isMultiplayer}) {
    int gridSize = (level == "Easy") ? 3 : (level == "Medium") ? 4 : 5;

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              isMultiplayer: isMultiplayer,
              gridSize: gridSize,
              difficulty: level,
            ),
          ),
        );
      },
      child: Text(level, style: TextStyle(color: Colors.white, fontSize: 16),),
    );
  }
}
