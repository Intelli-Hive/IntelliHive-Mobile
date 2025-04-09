import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intellihive_mobile_app/Pages/Profile_Page/Welcome_Page/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Login_Page/login_page.dart';
import 'Login_Page/rounded_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUserLoggedOut = FirebaseAuth.instance.currentUser == null;
  @override
  void initState() {
    super.initState();
    if (isUserLoggedOut) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profil()),
        );
      });
    }
    //TODO sorun cikarsa buraya bak cikis yap butonu ve yukarıdaki isUserLoggedOut kontrolu eklendi
  }

  static const String _title = 'Profil Sayfası';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePageMain(),
    );
  }
}


class ProfilePageMain extends StatelessWidget {
  const ProfilePageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Düzenleme butonuna tıklama işlemleri buraya eklenebilir
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kullanıcı Bilgileri',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                              String userPhoneNumber = userData['phoneNumber'] ?? "Telefon Numarası Yok";
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileInfoRow(
                                    label: 'Kullanıcı Adı',
                                    value: userName,
                                  ),
                                  ProfileInfoRow(
                                    label: 'E-posta Adresi',
                                    value: userEmail,
                                  ),
                                  ProfileInfoRow(
                                    label: 'Telefon Numarası',
                                    value: userPhoneNumber,
                                  ),
                                ],
                              )
                              ;
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
              const SizedBox(height: 20),
              ProfileInfoRow(
                label: 'Üyelik Tarihi',
                value: '01.01.2025',
              ),
              // Diğer bilgiler buraya eklenebilir
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Düzenleme butonuna tıklama işlemleri buraya eklenebilir
                },
                icon: const Icon(Icons.edit),
                label: const Text('Bilgileri Düzenle'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  primary: Colors.blue,
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
              InkWell(
                onTap: () async {
                  final Uri uri = Uri.parse('https://intelli-hive.github.io/comodobee.com'); // kendi linkin

                  final bool? userConfirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Dış bağlantı'),
                        content: const Text(
                            'Web sitemiz internet tarayıcınızda açılacaktır. Devam edilsin mi?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Vazgeç'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Devam Et'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (userConfirmed == true) {
                    final bool launched = await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                    if (!launched) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bağlantı açılamadı.')),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.link, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Web Sitemizi Ziyaret Edin!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}