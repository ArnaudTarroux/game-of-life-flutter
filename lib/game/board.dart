import 'dart:collection';

import 'package:gameoflifeflutter/game/cell.dart';

class Board {
  final HashSet<Cell> _cells = HashSet<Cell>();
  final int _height, _width;

  Board(this._height, this._width, {HashSet<Cell>? initialCells}) {
    if (initialCells != null) {
      _cells.addAll(initialCells);
    }
  }

  HashSet<Cell> get cells => _cells;

  Board addCell(Cell cell) {
    _cells.add(cell);
    return this;
  }

  bool isCellAlive(Cell cell) {
    return _cells.contains(cell);
  }

  Board nextIteration() {
    final board = Board(_height, _width);
    List<Cell> cellsMayNeedToReborn = [];

    for (var cell in _cells) {
      if (_isCellStayAliveInNextIteration(cell)) {
        board.addCell(cell);
      }
      cellsMayNeedToReborn.addAll(cell.getNeighbors());
    }

    for (var cell in cellsMayNeedToReborn) {
      if (_cellShouldReborn(cell)) {
        board.addCell(cell);
      }
    }

    return board;
  }

  bool _isCellStayAliveInNextIteration(Cell cell) {
    return getNeighbors(cell).length == 2 || getNeighbors(cell).length == 3;
  }

  Iterable<Cell> getNeighbors(Cell cell) {
    final neighborhood = cell.getNeighbors();
    return neighborhood.where((Cell neighborsCell) => isCellAlive(neighborsCell));
  }

  bool _cellShouldReborn(Cell cell) {
    return !isCellAlive(cell) && getNeighbors(cell).length == 3;
  }
}