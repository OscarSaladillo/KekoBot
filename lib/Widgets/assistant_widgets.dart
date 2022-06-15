import 'package:chat_bot/ChatBot/functionalities.dart';
import 'package:chat_bot/ChatBot/push_to_game.dart';
import 'package:chat_bot/ChatBot/send_game_info.dart';
import 'package:chat_bot/Providers/chatbot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elevatedButton.dart';

Widget getGameButtons(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 100,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              goToRoulette(context);
            }, "Ruleta"),
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              goToSlotMachine(context);
            }, "Tragaperras")
          ],
        ),
        elevatedButton(() {
          Provider.of<ChatBotProvider>(context, listen: false)
              .setWidget(Container(), true);
          goToBlackJack(context);
        }, "Blackjack")
      ],
    ),
  );
}

Widget getInfoButtons(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 100,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              sendKekoHouseInfo(context);
            }, "General"),
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              sendRouletteInfo(context);
            }, "Ruleta"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              sendSlotMachineInfo(context);
            }, "Tragaperras"),
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              sendBlackJackInfo(context);
            }, "Blackjack"),
          ],
        )
      ],
    ),
  );
}

Widget getOptionButtons(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 100,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              seeMoney(context, "dinero");
            }, "Ver fichas"),
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              setInfoButtons(context);
            }, "Pedir Información"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              setGameButtons(context);
            }, "Elegir juego"),
            elevatedButton(() {
              Provider.of<ChatBotProvider>(context, listen: false)
                  .setWidget(Container(), true);
              resetMoney(context, "dinero");
            }, "Reiniciar cuenta bancaria"),
          ],
        )
      ],
    ),
  );
}
