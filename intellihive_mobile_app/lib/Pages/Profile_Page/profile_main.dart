import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intellihive_mobile_app/Pages/Profile_Page/Welcome_Page/profile_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Profil sayfasına otomatik olarak yönlendirme yap
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profil()),
      );
    });
  }

  static const String _title = 'Profil Sayfası';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                value: '01.01.2022',
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