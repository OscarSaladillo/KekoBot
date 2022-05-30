import 'package:flutter/cupertino.dart';

class AvatarProvider with ChangeNotifier {
  ImageProvider? _image;
  String? _avatar;

  ImageProvider? get image => _image;
  String? get avatar => _avatar;

  setImage(ImageProvider? image) {
    _image = image;
    notifyListeners();
  }

  setAvatar(String? avatar) {
    _avatar = avatar;
    notifyListeners();
  }
}
