import 'dart:math';

class AiBot {
  static int getBestMove(List<String> board, String difficulty) {
    List<int> available = [for (int i = 0; i < board.length; i++) if (board[i] == "") i];

    if (available.isEmpty) return -1; // No move available

    switch (difficulty) {
      case "Easy":
        return available[Random().nextInt(available.length)];
      case "Medium":
        return available.length > 1 ? available[available.length ~/ 2] : available[0];
      case "Hard":
        return available[0]; // This should implement a real AI algorithm for best moves
      default:
        return available[0];
    }
  }
}
