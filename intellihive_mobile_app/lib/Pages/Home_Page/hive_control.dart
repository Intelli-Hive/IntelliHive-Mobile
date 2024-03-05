import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HiveControl extends StatefulWidget {
  @override
  _HiveControlState createState() => _HiveControlState();
}

class _HiveControlState extends State<HiveControl> {
  double _sliderValue = 0.0;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kovan Kontrol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              value: _sliderValue,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
                _updateFirestore(value.toStringAsFixed(3));
              },
            ),
            Text('Petek Ağırlığı: ${_sliderValue.toStringAsFixed(3)} kg'),
          ],
        ),
      ),
    );
  }

  void _updateFirestore(String value) async {
    final user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      CollectionReference userHives = FirebaseFirestore.instance
          .collection('Hives')
          .doc('UserHives')
          .collection(uid);

        await userHives.doc('LH7fzOw2zLZm3d9cgRGL').update({
          'kovan_agirlik': value,
      });
    }
  }
}
