import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddService{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> AddHive({
    required String userId,
    required String kovan_plaka,
    required String kovan_sicaklik,
    required String kovan_nem,
    required String kovan_agirlik,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Hives')
          .doc('UserHives')
          .collection(userId)
          .add({
        'kovan_plaka': kovan_plaka,
        'kovan_sicaklik': kovan_sicaklik,
        'kovan_nem': kovan_nem,
        'kovan_agirlik': kovan_agirlik,
      });

      await FirebaseFirestore.instance
          .collection('AllHives')
          .add({
        'kovan_plaka': kovan_plaka,
        'kovan_sicaklik': kovan_sicaklik,
        'kovan_nem': kovan_nem,
        'kovan_agirlik': kovan_agirlik,
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  String getUserId() {
    User? user = auth.currentUser;
    String userId = user!.uid;
    return userId;
  }

}