import 'dart:io';

final numberMap = {
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "zero": 0,
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
};

final numberRegex = RegExp("(?=(${numberMap.keys.join("|")}))");

void main() async {
  final file = File("data/day1.txt");
  final lines = await file.readAsLines();

  final digits = lines.map((line) {
    final foundKeys = numberRegex.allMatches(line);
    final first = foundKeys.first.group(1);
    final last = foundKeys.last.group(1);

    return numberMap[first]! * 10 + numberMap[last]!;
  });

  final result = digits.reduce((a, b) => a + b);

  print(result);
}
