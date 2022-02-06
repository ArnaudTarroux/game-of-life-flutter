import 'package:flutter/material.dart';
import 'package:gameoflifeflutter/game/board.dart';
import 'package:gameoflifeflutter/game/cell.dart';
import 'package:gameoflifeflutter/game/game.dart';

const int height = 50;
const int width = 50;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Of Life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameOfLife(title: 'Game Of Life'),
    );
  }
}

class GameOfLife extends StatefulWidget {
  const GameOfLife({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GameOfLife> createState() => _GameOfLifeState();
}

class _GameOfLifeState extends State<GameOfLife> {
  final Game _game = Game(
    iterationSpeed: const Duration(milliseconds: 500),
    height: height,
    width: width,
  );

  void _toggleGameState() {
    _game.toggleState();
  }
  void _resetGame() {
    _game.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: _game.gameBoardController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text('Please, click on the "play" button to launch a new game...');
            }

            Board board = snapshot.data as Board;
            final rows = List<int>.generate(width, (i) => i + 1);
            final columns = List.generate(height, (i) => i + 1);
            return Table(
              children: [
                for (var x in rows) TableRow(
                  children: [
                    for (var y in columns) TableCell(
                        child: (board.isCellAlive(Cell(x, y))) ?
                        const Text('   ', style: TextStyle(backgroundColor: Colors.lightGreen),) :
                        const Text('   ', style: TextStyle(backgroundColor: Colors.white),),
                    )
                  ],
                )
              ],
            );
          }
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleGameState,
            child: StreamBuilder(
              stream: _game.gameStateController.stream,
              builder: (context, snapshot) {
                if (snapshot.data == GameState.running) {
                  return const Icon(Icons.pause);
                }
                if (snapshot.data == GameState.paused) {
                  return const Icon(Icons.play_arrow);
                }

                return const Icon(Icons.play_arrow_outlined);

              },
            ),
          ),
          StreamBuilder(
            stream: _game.gameStateController.stream,
            builder: (context, snapshot) {
              if (snapshot.data != GameState.notStarted) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FloatingActionButton(
                    onPressed: _resetGame,
                    child: const Icon(Icons.subdirectory_arrow_left)
                  )
                );
              }

              return Container();
            }
          ),
        ],
      )
    );
  }
}
