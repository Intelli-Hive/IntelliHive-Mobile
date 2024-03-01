import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Welcome_Page/background.dart';
import '../Login_Page/login_page.dart';
import '../Login_Page/rounded_button.dart';
import '../SignUp_Page/sign_up_page.dart';

class Body extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text(
                "Apartev'e Hoşgeldiniz!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (authSnapshot.hasError) {
                  return Text("Error: ${authSnapshot.error}");
                } else {
                  if (authSnapshot.data != null) {
                    // Kullanıcı oturum açmışsa Firestore'dan verileri çek
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(authSnapshot.data!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          if (snapshot.data != null && snapshot.data!.exists) {
                            Map<String, dynamic> userData = snapshot.data!.data()! as Map<String, dynamic>;
                            String userEmail = userData['email'] ?? "Email yok";
                            String userName = userData['username'] ?? "Kullanıcı Adı Yok";
                            return Text(userEmail + "\n" + userName);
                          } else {
                            return Text("Kullanıcı verisi bulunamadı.");
                          }
                        }
                      },
                    );
                  } else {
                    return Text("Kullanıcı girişi yapılmadı..");
                  }
                }
              },
            ),
              SizedBox(height: size.height * 0.02),
              SvgPicture.asset(
                  "images/chat.svg",
                height: size.height * 0.40,
              ),
              SizedBox(height: size.height * 0.01),
              RoundedButton(
                text: "Giriş Yap",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return Login();},),);
                },
                color: Colors.deepPurpleAccent.withOpacity(0.8),
              ),
              RoundedButton(
                text: "Üye Ol",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return SignUp();},),);
                },
                color: Colors.purpleAccent.withOpacity(0.7),
              ),
              RoundedButton(
                text: "Çıkış Yap",
                press: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    // Çıkış başarılı olursa, örneğin giriş sayfasına yönlendirme yapabilirsiniz.
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  } catch (e) {
                    // Hata durumunda ekrana hata mesajını göstermek için bir SnackBar kullanabilirsiniz.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Çıkış yaparken bir hata oluştu.'),
                      ),
                    );
                  }
                },
                color: Colors.redAccent.withOpacity(0.7),
              ),
          ],
                ),
        ),
      );
  }
}
