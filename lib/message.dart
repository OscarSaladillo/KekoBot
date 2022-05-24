import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container getMessageContainer(String currentEmail, Map message, double width,
    Map<String, String> userColors) {
  return Container(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: (currentEmail == message["email"])
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            width: width,
            decoration: BoxDecoration(
                color: (currentEmail == message["email"])
                    ? Colors.greenAccent
                    : Color(int.parse(
                        userColors[message["email"]] ?? "0xFFFFFFFF")),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message["email"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  message["text"],
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )),
      ));
}
