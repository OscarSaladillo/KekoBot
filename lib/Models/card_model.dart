import 'dart:ui';

class CardModel {
  String symbol;
  int number;
  Color color;

  CardModel(this.number, this.symbol, this.color);

  String translateNumber() {
    List<String> letters = [
      "A",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "J",
      "Q",
      "K"
    ];
    return letters[number];
  }

  int getValue() {
    List<int> numbers = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
    return numbers[number];
  }
}
