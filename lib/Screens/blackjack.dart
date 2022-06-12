import 'dart:math';

import 'package:chat_bot/Providers/blackjack_provider.dart';
import 'package:chat_bot/Widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BlackJack extends StatefulWidget {
  const BlackJack({Key? key}) : super(key: key);

  @override
  State<BlackJack> createState() => _BlackJackState();
}

class _BlackJackState extends State<BlackJack> {
  TextEditingController betCtrl = TextEditingController();
  bool isStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void checkConditions() {
    if (!isStarted) {
      isStarted = !isStarted;
      Provider.of<BlackJackProvider>(context, listen: false).startMatch();
    } else {
      showSnackBar(
          "Ya empezaste la partida. Acaba la partida o retirate para empezar otra");
    }
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BlackJack"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: max(600, MediaQuery.of(context).size.height - 110),
          child: Consumer<BlackJackProvider>(
              builder: (context, handInfo, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        handInfo.botValue.toString(),
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(handInfo.botHand.length,
                            (index) => card(handInfo.botHand[index]),
                            growable: true),
                      ),
                      coverCard(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                            handInfo.playerHand.length,
                            (index) => card(handInfo.playerHand[index]),
                            growable: true),
                      ),
                      Text(
                        handInfo.playerValue.toString() + handInfo.playerState,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (isStarted) {
                                  handInfo.addToPlayerHand();
                                  isStarted = !handInfo.isFinished;
                                } else {
                                  showSnackBar(
                                      "Debes apostar y empezar la partida");
                                }
                              },
                              child: const Text(
                                'Robar',
                                style: TextStyle(fontFamily: "Casino"),
                              ),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF680000)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color(0xFFFFFFFF),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(30.0))))),
                          ElevatedButton(
                              onPressed: () {
                                if (!isStarted) {
                                  showSnackBar(
                                      "Debes apostar y empezar la partida");
                                } else {
                                  handInfo.addToBotHand(true);
                                  isStarted = !isStarted;
                                }
                              },
                              child: const Text(
                                'Dejar',
                                style: TextStyle(fontFamily: "Casino"),
                              ),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF680000)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color(0xFFFFFFFF),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(30.0))))),
                          ElevatedButton(
                              onPressed: () {
                                if (isStarted) {
                                  handInfo.giveUp();
                                  isStarted = false;
                                } else {
                                  showSnackBar(
                                      "Debes apostar y empezar la partida");
                                }
                              },
                              child: const Text(
                                'Retirar',
                                style: TextStyle(fontFamily: "Casino"),
                              ),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF680000)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color(0xFFFFFFFF),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(30.0)))))
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: betCtrl,
                          maxLines: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: const TextInputType.numberWithOptions(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              suffixIcon: TextButton(
                                onPressed: () {
                                  if (betCtrl.text.isNotEmpty) {
                                    handInfo.setBet(betCtrl.text);
                                    checkConditions();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    isStarted = !handInfo.isFinished;
                                  } else {
                                    showSnackBar("Debes apostar una cantidad");
                                  }
                                },
                                child: const Text(
                                  'Empezar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Casino"),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              labelStyle: const TextStyle(color: Colors.white),
                              labelText: 'Cantidad a apostar'),
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
