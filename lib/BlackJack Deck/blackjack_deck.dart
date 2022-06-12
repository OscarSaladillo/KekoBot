import 'package:flutter/material.dart';

import '../Models/card_model.dart';

List<CardModel> getBlackJackDeck() {
  List<CardModel> deck = [];
  List<String> symbols = ["clubs", "spades", "heart", "diamond"];
  for (int i = 0; i < 52; i++) {
    deck.add(CardModel(
        i % 13, symbols[i ~/ 13], (i < 26) ? Colors.black : Colors.red));
  }
  return deck;
}
