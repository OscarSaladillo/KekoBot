import 'package:chat_bot/Models/message_model.dart';
import 'package:flutter/material.dart';

Container getMessageContainer(
    String currentEmail, MessageModel message, String username, double width) {
  return Container(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: (currentEmail == message.email)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            width: width,
            decoration: BoxDecoration(
                color: (currentEmail == message.email)
                    ? const Color(0xFF680000)
                    : const Color(0xFF000000),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text(
                  message.text,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            )),
      ));
}
