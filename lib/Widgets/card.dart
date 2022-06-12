import 'package:chat_bot/Models/card_model.dart';
import 'package:flutter/material.dart';

Container coverCard() {
  return Container(
    height: 76,
    width: 55,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/blackjack_images/card back black.png"),
            fit: BoxFit.cover)),
  );
}

Container card(CardModel card) {
  return Container(
    height: 76,
    width: 55,
    color: Colors.white,
    child: Stack(
      children: [
        Positioned(
          child: Text(
            card.translateNumber(),
            style: TextStyle(color: card.color),
          ),
          top: 2,
          left: 2,
        ),
        Positioned(
          child: Image.asset(
            "assets/blackjack_images/" + card.symbol + ".png",
            width: 10,
          ),
          top: 18,
          left: 5,
        ),
        Align(
          child: Image.asset(
            "assets/blackjack_images/" + card.symbol + ".png",
            width: 20,
          ),
          alignment: Alignment.center,
        ),
        Positioned(
          child: RotatedBox(
              quarterTurns: 2,
              child: Text(card.translateNumber(),
                  style: TextStyle(color: card.color))),
          bottom: 2,
          right: 2,
        ),
        Positioned(
          child: RotatedBox(
              quarterTurns: 2,
              child: Image.asset(
                "assets/blackjack_images/" + card.symbol + ".png",
                width: 10,
              )),
          bottom: 17,
          right: 5,
        )
      ],
    ),
  );
}
