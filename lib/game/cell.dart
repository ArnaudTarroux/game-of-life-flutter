import 'dart:collection';

class Cell {
  final int _x, _y;

  Cell(this._x, this._y);

  int get x => _x;
  int get y => _y;

  HashSet<Cell> getNeighbors() {
    var neighbors = HashSet<Cell>();
    for (var x = -1; x <= 1; x++) {
      for (var y = -1; y <= 1; y++) {
        neighbors.add(Cell(_x + x, _y + y));
      }
    }
    neighbors.removeWhere((Cell neighborsCell) => neighborsCell == this);

    return neighbors;
  }

  @override
  int get hashCode => (_x << 8) + _y;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}