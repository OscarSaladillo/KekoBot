import 'dart:convert';
import 'dart:typed_data';

Uint8List convertBase64Image(String base64String) {
  return const Base64Decoder().convert(base64String.split(',').last);
}
