import 'package:flutter/material.dart';

ElevatedButton elevatedButton(void Function() onPressed, name) {
  return ElevatedButton(
      onPressed: onPressed,
      child: Text(name),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
          backgroundColor: MaterialStateProperty.all(const Color(0xFF680000)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.black, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(30.0)))));
}
