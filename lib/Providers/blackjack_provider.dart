import 'dart:math';

import 'package:chat_bot/BlackJack%20Deck/blackjack_deck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/card_model.dart';

class BlackJackProvider extends ChangeNotifier {
  List<CardModel> deck = getBlackJackDeck();
  List<CardModel> playerHand = [], botHand = [];
  int playerValue = 0, botValue = 0;
  int playerHasA = 0, botHasA = 0;
  bool _isFinished = false, _isWinner = false;
  String _playerState = "";
  int bet = 0;

  bool get isFinished => _isFinished;
  bool get isWinner => _isWinner;
  String get playerState => _playerState;

  setBet(String bet) {
    this.bet = int.parse(bet);
  }

  addToPlayerHand() {
    Random random = Random();
    CardModel card = deck[random.nextInt(deck.length)];
    while (playerHand.contains(card)) {
      card = deck[random.nextInt(deck.length)];
    }
    playerHand.add(card);
    playerValue += card.getValue();
    if (card.number == 0) {
      playerHasA++;
    }
    if (playerValue > 21) {
      _isFinished = checkPlayerHand();
      if (_isFinished) {
        _playerState = " (Derrota)";
        _isWinner = false;
      }
    } else if (playerValue == 21) {
      _isFinished = true;
      _playerState = " (BlackJack)";
      _isWinner = true;
    }
    notifyListeners();
  }

  bool checkPlayerHand() {
    if (playerHasA > 0) {
      while (playerHasA > 0 && playerValue > 21) {
        playerHasA--;
        playerValue -= 10;
      }
    }
    return playerValue > 21;
  }

  addToBotHand(bool isStarted) {
    Random random = Random();
    CardModel card = deck[random.nextInt(deck.length)];
    while (playerHand.contains(card)) {
      card = deck[random.nextInt(deck.length)];
    }
    botHand.add(card);
    botValue += card.getValue();
    if (card.number == 0) {
      botHasA++;
    }
    if (botValue > 21) {
      _isFinished = checkPlayerHand();
      _isWinner = checkPlayerHand();
      _playerState = " (Victoria)";
      _isWinner = true;
    }
    if (isStarted && botValue < 22) {
      if (botValue >= 17) {
        checkWinner();
      } else {
        addToBotHand(true);
      }
    }
    notifyListeners();
  }

  bool checkBotHand() {
    if (botHasA > 0) {
      while (botHasA > 0 && botValue > 21) {
        botHasA--;
        botValue -= 10;
      }
    }
    return botValue > 21;
  }

  void checkWinner() {
    _isWinner = playerValue > botValue;
    _isFinished = true;
    _playerState = (_isWinner)
        ? " (Victoria)"
        : (playerValue == botValue)
            ? " (Empate)"
            : " (Derrota)";
    notifyListeners();
  }

  void giveUp() {
    _isWinner = false;
    _isFinished = true;
    _playerState = " (Retirado)";
    notifyListeners();
  }

  void startMatch() {
    resetHands();
    addToPlayerHand();
    addToPlayerHand();
    addToBotHand(false);
  }

  resetHands() {
    playerHand.clear();
    botHand.clear();
    playerValue = 0;
    botValue = 0;
    playerHasA = 0;
    botHasA = 0;
    _playerState = "";
    _isFinished = false;
    notifyListeners();
  }
}
