import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gameoflifeflutter/game/board.dart';
import 'package:gameoflifeflutter/game/cell.dart';

enum GameState {
  running,
  paused,
  notStarted,
}

class Game {
  GameState _state = GameState.notStarted;
  final StreamController<Board> _gameController = StreamController<Board>.broadcast();
  final StreamController<GameState> _gameState = StreamController<GameState>.broadcast(sync: true);
  Board? _currentBoard;
  final Duration iterationSpeed;
  final int height, width;

  Game({
    required this.iterationSpeed,
    required this.height,
    required this.width,
  }) {
    _gameState.add(_state);
  }

  StreamController<GameState> get gameStateController => _gameState;
  StreamController<Board> get gameBoardController => _gameController;

  void toggleState() {
    print("Toggle State");
    if (_state == GameState.notStarted) {
      _runGame();
      return;
    }

    _state = (_state == GameState.running) ? GameState.paused : GameState.running;
    _runGame();
  }

  void reset() {
    print("ResetGame");
    _state = GameState.notStarted;
    gameStateController.add(_state);
    _runGame();
  }

  _runGame() async {
    if (_state == GameState.notStarted) {
      _currentBoard = Board(height, width, initialCells: _initCells(height, width));
      _state = GameState.running;
    }
    _gameState.add(_state);

    while (_state == GameState.running) {
      _currentBoard = _currentBoard?.nextIteration();
      _gameController.add(_currentBoard!);
      await Future.delayed(iterationSpeed);
    }
  }

  HashSet<Cell> _initCells(int height, int width) {
    HashSet<Cell> cells = HashSet();
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        var rand = Random.secure().nextInt(100);
        if (rand % 2 == 0) {
          cells.add(Cell(x, y));
        }
      }
    }

    return cells;
  }
}