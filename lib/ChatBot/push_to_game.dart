import 'package:flutter/cupertino.dart';

import '../Utils/add_message.dart';

Future<void> goToRoulette(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com", "Te llevo a la ruleta ^^");
  Navigator.pushNamed(context, "/roulette");
}

Future<void> goToSlotMachine(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com", "Te guio al tragaperras :)");
  Navigator.pushNamed(context, "/slotMachine");
}

Future<void> goToBlackJack(BuildContext context) async {
  await addMessage(
      context, "kekobot@kekobot.com", "A la mesa de blackjack se ha dicho ;)");
  Navigator.pushNamed(context, "/blackjack");
}
