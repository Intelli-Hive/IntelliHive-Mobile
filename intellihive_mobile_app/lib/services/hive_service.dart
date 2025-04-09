import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HiveService{
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> AddHive({
    required String userId,
    required String kovan_plaka,
    required String kovan_sicaklik,
    required String kovan_nem,
    required String kovan_agirlik,
    required String kovan_kapak_derece,
    required String kovan_kapak_on_off,
    required String kovan_petek_on_off,
    required String kovan_polen_on_off,
    required String kovan_buhar_on_off,
    required String kovan_petek_sayisi,
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
        'kovan_kapak_derece': kovan_kapak_derece,
        'kovan_kapak_on_off': kovan_kapak_on_off,
        'kovan_petek_sayisi': kovan_petek_sayisi,
        'kovan_petek_on_off': kovan_petek_on_off,
        'kovan_polen_on_off': kovan_polen_on_off,
        'kovan_buhar_on_off': kovan_buhar_on_off,
      });

      await FirebaseFirestore.instance
          .collection('Hives')
          .doc('AllHives')
          .collection('Datas')
          .add({
        'kovan_plaka': kovan_plaka,
        'kovan_sicaklik': kovan_sicaklik,
        'kovan_nem': kovan_nem,
        'kovan_agirlik': kovan_agirlik,
        'kovan_kapak_derece': kovan_kapak_derece,
        'kovan_kapak_on_off': kovan_kapak_on_off,
        'kovan_petek_sayisi': kovan_petek_sayisi,
        'kovan_petek_on_off': kovan_petek_on_off,
        'kovan_polen_on_off': kovan_polen_on_off,
        'kovan_buhar_on_off': kovan_buhar_on_off,
      });
    } catch (e) {
      print('Hata: $e');
    }
  }


  Future<Stream<QuerySnapshot>> getHiveData(String userId) async {
    return await _firestore
          .collection('Hives')
          .doc('UserHives')
          .collection(userId)
          .snapshots();
  }

  String getUserId() {
    User? user = auth.currentUser;
    String userId = user!.uid;
    return userId;
  }

}