import 'package:firebase_auth/firebase_auth.dart';

class GetId{
  FirebaseAuth auth = FirebaseAuth.instance;

  String getUserId() {
    User? user = auth.currentUser;
    String userId = user!.uid;
    return userId;
  }

}