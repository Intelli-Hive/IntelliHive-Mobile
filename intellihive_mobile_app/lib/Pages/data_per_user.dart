import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellihive_mobile_app/Pages/Home_Page/hive_control.dart';


class DataPerUserPage extends StatefulWidget {
  final String title;

  DataPerUserPage({Key? key, required this.title}) : super(key: key);

  @override
  _DataPerUserPageState createState() => _DataPerUserPageState();
}

class _DataPerUserPageState extends State<DataPerUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
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
                    .collection('Hives')
                    .doc('UserHives') // Eğer belirli bir belge adı varsa, buraya ekle
                    .collection(authSnapshot.data!.uid) // Kullanıcının UID'si ile koleksiyona eriş
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    if (snapshot.data != null) {
                      // Verileri işle
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          String kovan_plaka = data['kovan_plaka'] ?? "Değer Yok";
                          String kovan_sicaklik = data['kovan_sicaklik'] ?? "Değer Yok";
                          String kovan_nem = data['kovan_nem'] ?? "Değer Yok";
                          String kovan_agirlik = data['kovan_agirlik'] ?? "Değer Yok";

                          return BeehiveCard(
                            hiveName: kovan_plaka,
                            temperature: kovan_sicaklik,
                            humidity: kovan_nem,
                            weight: kovan_agirlik,
                            numBars: 3,
                          );
                        }).toList(),
                      );

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
      )

    );
  }
}


class BeehiveCard extends StatelessWidget {
  final String hiveName;
  final String humidity;
  final String temperature;
  final String weight;
  final int numBars;

  BeehiveCard({
    required this.hiveName,
    required this.humidity,
    required this.temperature,
    required this.weight,
    required this.numBars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hiveName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nem: ${humidity}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Sıcaklık: ${temperature}°C',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              numBars,
                  (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ağırlık: ${weight}kg',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {return HiveControl();},),);
              // Butona basıldığında yapılacak işlemler buraya yazılabilir
            },
            child: const Text('İncele'),
          ),
        ],
      ),
    );
  }
}