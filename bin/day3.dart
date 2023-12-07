import 'dart:io';

void main() async {
  final lines = await File("data/day3.txt").readAsLines();

  final board = Board.fromLines(lines);

  final numbers = board.cells.whereType<Number>();
  final numbersWithSymbolNeighbours = numbers.where((n) => n.neighbours.isNotEmpty);
  final numbersSum = numbersWithSymbolNeighbours.fold(0, (sum, n) => n.value + sum);

  final gearSums = board.cells
      .whereType<Symbol>()
      .where((symbol) => symbol.value == "*")
      .where((symbol) => symbol.neighbours.whereType<Number>().length == 2)
      .map((gear) => gear.neighbours.whereType<Number>().map((n) => n.value).reduce((a, b) => a * b))
      .reduce((a, b) => a + b);

  print(gearSums);
}

class Board {
  Board.fromLines(List<String> lines) {
    width = lines.first.length;
    height = lines.length;

    grid = List.generate(height * width, (_) => null, growable: false);

    for (int y = 0; y < height; y++) {
      final line = lines[y];

      final numbers = numbersRegex.allMatches(line);
      final symbols = symbolsRegex.allMatches(line);

      for (final match in numbers) {
        final x = match.start;
        final i = y * width + x;
        final value = match.group(1)!;

        final number = Number(
          board: this,
          x: x,
          y: y,
          value: int.parse(value),
          width: value.length,
        );

        for (int w = 0; w < number.width; w++) {
          grid[i + w] = number;
        }

        cells.add(number);
      }

      for (final match in symbols) {
        final x = match.start;
        final i = y * width + x;
        final value = match.group(1)!;

        final symbol = Symbol(
          board: this,
          x: x,
          y: y,
          value: value,
        );

        grid[i] = symbol;
        cells.add(symbol);
      }
    }
  }

  final numbersRegex = RegExp(r"(\d+)");
  final symbolsRegex = RegExp(r"([^\d|\.])");

  late final List<Cell?> grid;
  final List<Cell> cells = [];
  late final int width;
  late final int height;

  Cell? cellAt(int x, int y) {
    if (x < 0 || x >= width) return null;
    if (y < 0 || y >= height) return null;

    return grid[y * width + x];
  }
}

abstract class Cell {
  Cell({
    required this.board,
    required this.x,
    required this.y,
  });

  final Board board;
  final int x;
  final int y;

  List<(int x, int y)> get border => [
        (x - 1, y - 1),
        (x - 1, y),
        (x - 1, y + 1),
        (x, y - 1),
        (x, y + 1),
        (x + 1, y - 1),
        (x + 1, y),
        (x + 1, y + 1),
      ];

  List<Cell> get neighbours => border.map((d) => board.cellAt(d.$1, d.$2)).whereType<Cell>().toSet().toList();
}

class Number extends Cell {
  Number({
    required super.board,
    required super.x,
    required super.y,
    required this.value,
    required this.width,
  });

  final int value;
  final int width;

  @override
  List<(int x, int y)> get border => [
        for (int i = x - 1; i < x + width + 1; i++) ...[
          (i, y - 1),
          (i, y + 1),
        ],
        (x - 1, y),
        (x + width, y),
      ];

  @override
  String toString() => value.toString();
}

class Symbol extends Cell {
  Symbol({
    required super.board,
    required super.x,
    required super.y,
    required this.value,
  });

  final String value;

  @override
  String toString() => value;
}

final testLines = r"""467..114..
...*......
..35..633.
......#...
617+......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."""
    .split("\n");
