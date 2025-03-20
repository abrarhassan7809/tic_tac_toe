import 'package:flutter/material.dart';
import '../ai_logic/ai_bot.dart';

class GameScreen extends StatefulWidget {
  final bool isMultiplayer;
  final int gridSize;
  final String difficulty;

  const GameScreen({
    required this.isMultiplayer,
    required this.gridSize,
    required this.difficulty,
    super.key,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late List<String> board;
  bool isXturn = true;
  bool gameOver = false;
  String winner = "";
  List<int> winningPattern = [];

  int xWins = 0;
  int oWins = 0;

  late AnimationController _animationController;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();
    board = List.filled(widget.gridSize * widget.gridSize, "");

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.amberAccent,
    ).animate(_animationController);
  }

  void _handleTap(int index) {
    if (board[index] == "" && !gameOver) {
      setState(() {
        board[index] = isXturn ? "X" : "O";
        isXturn = !isXturn;
        _checkWinner();

        if (!widget.isMultiplayer && !isXturn && !gameOver) {
          Future.delayed(const Duration(milliseconds: 500), _botMove);
        }
      });
    }
  }

  void _botMove() {
    List<int> available = [for (int i = 0; i < board.length; i++) if (board[i] == "") i];
    if (available.isEmpty) return;

    int aiMove = AiBot.getBestMove(board, widget.difficulty);
    setState(() {
      board[aiMove] = "O";
      isXturn = true;
      _checkWinner();
    });
  }

  void _checkWinner() {
    int size = widget.gridSize;
    List<List<int>> winPatterns = [];

    for (int i = 0; i < size; i++) {
      winPatterns.add(List.generate(size, (j) => i * size + j)); // Rows
      winPatterns.add(List.generate(size, (j) => j * size + i)); // Columns
    }
    winPatterns.add(List.generate(size, (i) => i * size + i)); // Diagonal \
    winPatterns.add(List.generate(size, (i) => i * size + (size - 1 - i))); // Diagonal /

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != "" && pattern.every((index) => board[index] == board[pattern[0]])) {
        setState(() {
          gameOver = true;
          winner = board[pattern[0]];
          _highlightWinningTiles(pattern);

          // Increase the win counter for the winner
          if (winner == "X") {
            xWins++;
          } else {
            oWins++;
          }

        });
        return;
      }
    }

    if (!board.contains("")) {
      setState(() {
        gameOver = true;
        winner = "Draw";
      });
    }
  }

  void _highlightWinningTiles(List<int> pattern) {
    for (int i in pattern) {
      board[i] = board[i] == "X" ? "🏆X🏆" : "🏆O🏆";
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(widget.gridSize * widget.gridSize, "");
      isXturn = true;
      gameOver = false;
      winner = "";
      winningPattern = [];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    double availableHeight = MediaQuery.of(context).size.height * 0.7;
    double cellSize = screenSize / widget.gridSize - 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMultiplayer ? "Multiplayer Mode" : "${widget.difficulty} AI"),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.cyan.shade800,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display win counts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("X Wins: $xWins", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("O Wins: $oWins", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                gameOver ? (winner == "Draw" ? "It's a Draw!" : "$winner Wins!") : "Turn: ${isXturn ? "X" : "O"}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // Game Grid
              SizedBox(
                width: screenSize * 0.9,
                height: availableHeight,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.gridSize,
                    childAspectRatio: 1,
                  ),
                  itemCount: board.length,
                  itemBuilder: (context, index) {
                    bool isWinningTile = winningPattern.contains(index);
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        height: cellSize,
                        width: cellSize,
                        decoration: BoxDecoration(
                          gradient: isWinningTile
                              ? LinearGradient(
                            colors: [_glowAnimation.value!, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : LinearGradient(
                            colors: [Colors.cyan.shade900, Colors.black54],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),

                          boxShadow: [
                            if (isWinningTile)
                              BoxShadow(
                                color: _glowAnimation.value!,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Text(
                              board[index],
                              key: ValueKey(board[index]),
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (gameOver)
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 1, end: gameOver ? 1.2 : 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: ElevatedButton(
                        onPressed: _resetGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade900,
                          shadowColor: Colors.white,
                          elevation: 10,
                        ),
                        child: const Text("Restart Game", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
