import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/user_provider.dart';

Future<void> addMoney(BuildContext context, int money) async {
  DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(Provider.of<UserProvider>(context, listen: false).currentUser!.id)
      .get();
  DocumentReference? docRef = querySnap.reference;
  docRef.update({
    "money":
        Provider.of<UserProvider>(context, listen: false).currentUser!.money +
            money
  });
}

Future<void> resetAccount(BuildContext context) async {
  DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(Provider.of<UserProvider>(context, listen: false).currentUser!.id)
      .get();
  DocumentReference? docRef = querySnap.reference;
  docRef.update({"money": 500});
}
