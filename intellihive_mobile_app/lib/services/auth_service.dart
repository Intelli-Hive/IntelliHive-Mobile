import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intellihive_mobile_app/services/get_id_service.dart';


class AuthService{
  GetId getId = GetId();
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> singUp(BuildContext context, {required String username, required String email, required String phoneNumber, required String password}) async{
    final navigator = Navigator.of(context);
    try{
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        _registerUser(username: username, email: email, phoneNumber: phoneNumber, password: password);
        Fluttertoast.showToast(msg: "Kayıt Başarılı!");
        navigator.pop();
      }
    } on FirebaseAuthException catch (e){
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> singIn(BuildContext context, {required String email, required String password}) async{
    final navigator = Navigator.of(context);
    try{
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        Fluttertoast.showToast(msg: "Giriş Başarılı!");
        //navigator.push(MaterialPageRoute(builder: (context) => Anasayfa(),));
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e){
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser({required String username, required String email, required String phoneNumber, required String password}) async{
    await userCollection.doc(getId.getUserId()).set({
      "username" : username,
      "email" : email,
      "phoneNumber" : phoneNumber,
      "password" : password
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Kayıt bulunamadı: $e');
      return null;
    }
  }
}