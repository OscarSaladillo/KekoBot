import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slot_machine/slot_machine.dart';

class SlotMachineScreen extends StatefulWidget {
  const SlotMachineScreen({Key? key}) : super(key: key);

  @override
  _SlotMachineScreenState createState() => _SlotMachineScreenState();
}

class _SlotMachineScreenState extends State<SlotMachineScreen> {
  late SlotMachineController _controller;
  bool isRun = false;
  List<int> rewards = [3, 10, 5, 20, 50, 25, 10, 5, 100];

  @override
  void initState() {
    super.initState();
  }

  void onButtonTap({required int index}) {
    _controller.stop(reelIndex: index);
  }

  void onStart() {
    if (!isRun) {
      isRun = !isRun;
      final index = Random().nextInt(90);
      _controller.start(hitRollItemIndex: index < 9 ? index : null);
    }
  }

  bool checkResult(List<int> results) {
    return results[0] == results[1] && results[0] == results[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maquina Tragaperras"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/SlotMachineColor.jpg"),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/CasinoWorld_Logo.png",
                width: 200,
              ),
              SlotMachine(
                multiplyNumberOfSlotItems: 10,
                rollItems: [
                  RollItem(
                      index: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/apple.png"))),
                  RollItem(
                      index: 1,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/bar.png"))),
                  RollItem(
                      index: 2,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/cherry.png"))),
                  RollItem(
                      index: 3,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/crown.png"))),
                  RollItem(
                      index: 4,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child:
                              Image.asset("assets/slot_images/diamond.png"))),
                  RollItem(
                      index: 5,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/dice.png"))),
                  RollItem(
                      index: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/lemon.png"))),
                  RollItem(
                      index: 7,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/orange.png"))),
                  RollItem(
                      index: 8,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2)),
                          child: Image.asset("assets/slot_images/seven.png"))),
                ],
                onCreated: (controller) {
                  _controller = controller;
                },
                onFinished: (resultIndexes) {
                  print(resultIndexes);
                  print(checkResult(resultIndexes));
                  if (checkResult(resultIndexes)) {
                    print(rewards[resultIndexes[0]]);
                  }
                  isRun = !isRun;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: TextButton(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                                color: const Color(0xFF680000),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(36)),
                          ),
                          onPressed: () => onButtonTap(index: 0)),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: TextButton(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                                color: const Color(0xFF680000),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(36)),
                          ),
                          onPressed: () => onButtonTap(index: 1)),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: TextButton(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                                color: const Color(0xFF680000),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(36)),
                          ),
                          onPressed: () => onButtonTap(index: 2)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                    onPressed: () {
                      onStart();
                    },
                    child: const Text(
                      'Empezar',
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Casino"),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 50)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF680000)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30.0))))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
