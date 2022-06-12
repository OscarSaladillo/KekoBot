import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Roulette extends StatefulWidget {
  const Roulette({Key? key}) : super(key: key);

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  StreamController<int> selected = StreamController<int>();
  bool isRun = false;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> rewards = [
      20,
      -10,
      -30,
      30,
      -20,
      50,
      -40,
      100,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleta de la fortuna'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/rouletteColor.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/roulette_logo.png",
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            const Text(
              '10 Euros la tirada',
              style: TextStyle(
                  color: Colors.white, fontFamily: "Casino", fontSize: 24),
            ),
            GestureDetector(
                onTap: () async {
                  if (!isRun) {
                    int result = Fortune.randomInt(0, rewards.length);
                    isRun = true;
                    setState(() {
                      selected.add(
                        result,
                      );
                    });
                    await Future.delayed(
                        const Duration(seconds: 4, milliseconds: 3));
                    print(rewards[result]);
                    isRun = false;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.width - 50,
                  child: FortuneWheel(
                    indicators: const [
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ],
                    selected: selected.stream,
                    items: [
                      for (int i = 0; i < rewards.length; i++)
                        FortuneItem(
                            child: Text(rewards[i].toString()),
                            style: FortuneItemStyle(
                                color: (i % 2 == 0)
                                    ? Colors.black
                                    : const Color(0xFF680000),
                                borderColor: Colors.white,
                                borderWidth: 3)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
