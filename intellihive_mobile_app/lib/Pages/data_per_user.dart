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
  String? _selectedValue;
  bool _isElectricityChecked = false;
  List<bool> _electricityStates = [];
  CollectionReference? _userHives;

  final _kovanPetekOnOffController = TextEditingController();
  final _kovanKapakOnOffController = TextEditingController();
  final _kovanPolenOnOffController = TextEditingController();

  Future<void> _updateMotorsStatePetek(bool isElectricityOn,
      [DocumentSnapshot? documentSnapshot]) async {
    if (isElectricityOn) {
      if (documentSnapshot != null) {
        _kovanPetekOnOffController.text = 'true';
        // Veritabanını güncelle
        await _userHives
            ?.doc(documentSnapshot.id)
            .update({"kovan_petek_on_off": "true"});
      }
    } else {
      _kovanPetekOnOffController.text = 'false';
      // Veritabanını güncelle
      await _userHives
          ?.doc(documentSnapshot!.id)
          .update({"kovan_petek_on_off": "false"});
    }
  }

  Future<void> _updateMotorsStateKapak(bool isElectricityOn,
      [DocumentSnapshot? documentSnapshot]) async {
    if (isElectricityOn) {
      if (documentSnapshot != null) {
        _kovanKapakOnOffController.text = 'true';
        // Veritabanını güncelle
        await _userHives
            ?.doc(documentSnapshot.id)
            .update({"kovan_kapak_on_off": "true"});
      }
    } else {
      _kovanKapakOnOffController.text = 'false';
      // Veritabanını güncelle
      await _userHives
          ?.doc(documentSnapshot!.id)
          .update({"kovan_kapak_on_off": "false"});
    }
  }

  Future<void> _updateMotorsStatePolen(bool isElectricityOn,
      [DocumentSnapshot? documentSnapshot]) async {
    if (isElectricityOn) {
      if (documentSnapshot != null) {
        _kovanPolenOnOffController.text = 'true';
        // Veritabanını güncelle
        await _userHives
            ?.doc(documentSnapshot.id)
            .update({"kovan_polen_on_off": "true"});
      }
    } else {
      _kovanPolenOnOffController.text = 'false';
      // Veritabanını güncelle
      await _userHives
          ?.doc(documentSnapshot!.id)
          .update({"kovan_polen_on_off": "false"});
    }
  }

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
            return Center(child: CircularProgressIndicator());
          } else if (authSnapshot.hasError) {
            return Center(child: Text("Error: ${authSnapshot.error}"));
          } else {
            if (authSnapshot.data != null) {

              final userId = authSnapshot.data!.uid;
              _userHives = FirebaseFirestore.instance
                  .collection('Hives')
                  .doc('UserHives')
                  .collection(userId);

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Hives')
                    .doc('UserHives')
                    .collection(authSnapshot.data!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    if (snapshot.hasData) {
                      // Veritabanından gelen öğelerin sayısına göre electricityStates listesini ayarla
                      if (_electricityStates.length !=
                          snapshot.data!.docs.length) {
                        _electricityStates = List.generate(
                            snapshot.data!.docs.length, (_) => false);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          String kovanPlaka = data['kovan_plaka'] ?? "Değer Yok";
                          double kovanSicaklik = double.tryParse(data['kovan_sicaklik'].toString()) ?? 0.0;
                          double kovanNem = double.tryParse(data['kovan_nem'].toString()) ?? 0.0;
                          double kovanAgirlik = double.tryParse(data['kovan_agirlik'].toString()) ?? 0.0;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4.0,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.hive,
                                            size: 40.0,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            kovanPlaka,
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // Yuvarlak Chart ve ağırlık göstergesi
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              value: kovanAgirlik / 20, // 0-20 kg arasında değer
                                              backgroundColor: Colors.grey[200],
                                              color: Colors.green,
                                              strokeWidth: 8.0,
                                            ),
                                            Text(
                                              "$kovanAgirlik kg",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  // Sıcaklık ve Nem için Progress Bars
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Sıcaklık: ${kovanSicaklik.toStringAsFixed(1)}°C",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: LinearProgressIndicator(
                                                  value: kovanSicaklik / 100,
                                                  backgroundColor: Colors.grey[300],
                                                  color: Colors.redAccent,
                                                  minHeight: 8.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Nem: ${kovanNem.toStringAsFixed(1)}%",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: LinearProgressIndicator(
                                                  value: kovanNem / 100,
                                                  backgroundColor: Colors.grey[300],
                                                  color: Colors.blueAccent,
                                                  minHeight: 8.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  // Açma/Kapama Düğmeleri
                                  Column(
                                    children: [
                                      // Düğme etiketleri
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Petek", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                          Text("Kapak", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                          Text("Polen", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      // Switchler
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Switch(
                                            value: _electricityStates[index],
                                            // Her bir öğe için ayrı bir durum
                                            onChanged: (value) {
                                              setState(() {
                                                _electricityStates[index] =
                                                    value; // Değeri değiştir
                                              });
                                              _updateMotorsStatePetek(
                                                  _electricityStates[index],
                                                  document); // Değişiklik yapıldığında _update metodu çalışsın
                                            },
                                            activeTrackColor: Colors.lightGreenAccent,
                                            activeColor: Colors.green,
                                          ),
                                          Switch(
                                            value: _electricityStates[index],
                                            // Her bir öğe için ayrı bir durum
                                            onChanged: (value) {
                                              setState(() {
                                                _electricityStates[index] =
                                                    value; // Değeri değiştir
                                              });
                                              _updateMotorsStateKapak(
                                                  _electricityStates[index],
                                                  document); // Değişiklik yapıldığında _update metodu çalışsın
                                            },
                                            activeTrackColor: Colors.lightGreenAccent,
                                            activeColor: Colors.green,
                                          ),
                                          Switch(
                                            value: _electricityStates[index],
                                            // Her bir öğe için ayrı bir durum
                                            onChanged: (value) {
                                              setState(() {
                                                _electricityStates[index] =
                                                    value; // Değeri değiştir
                                              });
                                              _updateMotorsStatePolen(
                                                  _electricityStates[index],
                                                  document); // Değişiklik yapıldığında _update metodu çalışsın
                                            },
                                            activeTrackColor: Colors.lightGreenAccent,
                                            activeColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("Kullanıcı verisi bulunamadı."));
                    }
                  }
                },
              );
            } else {
              return Center(child: Text("Kullanıcı girişi yapılmadı."));
            }
          }
        },
      ),
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