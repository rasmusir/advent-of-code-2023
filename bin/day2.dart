import 'dart:io';
import 'dart:math';

final regex = RegExp(r"Game\s*(\d+):(.*)");

void main() async {
  final lines = await File("data/day2.txt").readAsLines();

  final games = lines.map(Game.fromLine);

  final validGames = games.where((game) => game.isValid());

  final firstResult = validGames.fold(0, (sum, game) => sum + game.id);

  final secondResult = games.fold(0, (sum, game) => sum + game.getLargestPossibleSet().getPower());

  print(firstResult);
  print(secondResult);
}

class Game {
  Game.fromLine(String line) {
    final [id, data] = regex.firstMatch(line)!.groups([1, 2]);

    if (id == null || data == null) return;

    this.id = int.parse(id);
    final sets = data.split(";");
    this.sets = sets.map(Set.fromData).toList();
  }

  late final int id;
  late final List<Set> sets;

  bool isValid() => sets.every((set) => set.isValid());

  Set getLargestPossibleSet() {
    final largestReds = sets.fold(0, (largest, set) => max(largest, set.reds));
    final largestGreens = sets.fold(0, (largest, set) => max(largest, set.greens));
    final largestBlues = sets.fold(0, (largest, set) => max(largest, set.blues));

    return Set(
      reds: largestReds,
      greens: largestGreens,
      blues: largestBlues,
    );
  }
}

class Set {
  Set.fromData(String data) {
    final cubes = data.split(",").map((e) => e.trim());

    reds = int.parse(cubes.where((cube) => cube.endsWith("red")).firstOrNull?.split(" ")[0] ?? "0");
    greens = int.parse(cubes.where((cube) => cube.endsWith("green")).firstOrNull?.split(" ")[0] ?? "0");
    blues = int.parse(cubes.where((cube) => cube.endsWith("blue")).firstOrNull?.split(" ")[0] ?? "0");
  }

  Set({
    required this.reds,
    required this.greens,
    required this.blues,
  });

  late final int reds;
  late final int greens;
  late final int blues;

  bool isValid() => reds <= 12 && greens <= 13 && blues <= 14;

  int getPower() => reds * greens * blues;
}
