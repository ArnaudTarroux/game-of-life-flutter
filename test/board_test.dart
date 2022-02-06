import 'package:gameoflifeflutter/game/board.dart';
import 'package:gameoflifeflutter/game/cell.dart';
import 'package:test/test.dart';

void main() {
  test('An isolated cell should not have neighbords', () {
    final board = Board(10, 10);
    board.addCell(Cell(5, 5));

    Iterable<Cell> neighbors = board.getNeighbors(Cell(5, 5));

    expect(neighbors.length, 0);
  });

  test('Two neighbors only cells should die on next iteration', () {
    final board = Board(10, 10);
    board.addCell(Cell(5, 5));
    board.addCell(Cell(4, 5));

    final newBoard = board.nextIteration();

    expect(newBoard.cells.length, 0);
  });

  test('Three neighbors cells should live on next iteration And one should reborn', () {
    final board = Board(10, 10);
    board.addCell(Cell(5, 5));
    board.addCell(Cell(4, 5));
    board.addCell(Cell(5, 4));

    final newBoard = board.nextIteration();

    expect(newBoard.cells.length, 4);
  });
}