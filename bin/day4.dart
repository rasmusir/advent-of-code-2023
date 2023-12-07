import 'dart:io';
import 'dart:math';

void main() {
  partOne();
  partTwo();
}

void partOne() => print(
      File("data/day4.txt")
          .readAsLinesSync()
          .map((line) => line.split(":").last)
          .map((line) => line.split("|"))
          .map((card) => (
                winning: RegExp(r"\d+").allMatches(card.first).map((matches) => matches[0]),
                numbers: RegExp(r"\d+").allMatches(card.last).map((matches) => matches[0]),
              ))
          .map((card) => card.numbers.where((number) => card.winning.contains(number)).length)
          .map((winningNumbers) => pow(2, winningNumbers - 1).toInt())
          .reduce((sum, points) => sum + points),
    );

void partTwo() async {
  final lines = await File("data/day4.txt").readAsLines();

  final cards = lines.map(Card.fromLine).toList();

  for (var card in cards) {
    card.setCards(cards);
  }

  final prizes = [for (var card in cards) ...card.prizes];

  print(prizes.length + cards.length);
}

class Card {
  Card.fromLine(String source) {
    final match = _cardSplitter.firstMatch(source);
    final [sourceId!, sourceWinningNumbers!, sourceNumbers!] = match!.groups([1, 2, 3]);

    id = int.parse(sourceId);

    winningNumbers = sourceWinningNumbers //
        .split(" ")
        .where((n) => n.isNotEmpty)
        .map(int.parse)
        .toList();

    numbers = sourceNumbers //
        .split(" ")
        .where((n) => n.isNotEmpty)
        .map(int.parse)
        .toList();
  }

  static final _cardSplitter = RegExp(r"Card\s+(\d+):(.*?)\|(.*?)$");

  late final int id;
  late final List<int> winningNumbers;
  late final List<int> numbers;
  late final List<Card> _cards;

  late final correctNumbers = numbers.where((number) => winningNumbers.contains(number)).length;
  late final prizes = calculatePrizes();

  void setCards(List<Card> cards) => _cards = cards;

  List<Card> calculatePrizes() {
    final directPrizes = _cards //
        .skip(id)
        .take(correctNumbers);

    return [
      ...directPrizes,
      ...directPrizes //
          .map((card) => card.prizes)
          .expand((prizes) => prizes),
    ];
  }
}

final testData = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"""
    .split("\n");
