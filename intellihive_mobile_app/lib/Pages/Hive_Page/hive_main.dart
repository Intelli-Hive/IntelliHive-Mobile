import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intellihive_mobile_app/Pages/Hive_Page/new_hive.dart';

class AddHivePage extends StatefulWidget {
  AddHivePage({Key? key}) : super(key: key);

  @override
  State<AddHivePage> createState() => _AddHivePageState();
}

class _AddHivePageState extends State<AddHivePage> {
  String? _selectedValue;
  bool _isElectricityChecked = false;
  List<bool> _electricityStates = [];
  CollectionReference? _userHives;

  final _kovanPlakaController = TextEditingController();
  final _kovanSicaklikController = TextEditingController();
  final _kovanNemController = TextEditingController();
  final _kovanAgirlikController = TextEditingController();
  final _kovanKapakDereceController = TextEditingController();
  final _kovanKapakOnOffController = TextEditingController();
  final _kovanPetekSayisiController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _kovanPlakaController.text = documentSnapshot['kovan_plaka'];
      _kovanSicaklikController.text = documentSnapshot['kovan_sicaklik'];
      _kovanNemController.text = documentSnapshot['kovan_nem'];
      _kovanAgirlikController.text = documentSnapshot['kovan_agirlik'];
      _kovanKapakDereceController.text = documentSnapshot['kovan_kapak_derece'];
      _kovanKapakOnOffController.text = documentSnapshot['kovan_kapak_on_off'];
      _kovanPetekSayisiController.text = documentSnapshot['kovan_petek_sayisi'];
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _kovanPlakaController,
                decoration: const InputDecoration(labelText: 'Kovan Plakası'),
              ),
              const SizedBox(height: 30),
              Text(
                'Kovan Kapağı Açıklık Seviyesi',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 30; i <= 180; i += 30)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedValue = i.toString();
                              _kovanKapakDereceController.text =
                              _selectedValue!;
                            });
                          },
                          child: Text(i.toString()),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              TextField(
                controller: _kovanKapakDereceController,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Güncelle'),
                onPressed: () async {
                  final String plaka = _kovanPlakaController.text;
                  //final String sicaklik = _kovanSicaklikController.text;
                  //final String nem = _kovanNemController.text;
                  final String kapak_derece = _kovanKapakDereceController.text;
                  if (plaka != null) {
                    await _userHives?.doc(documentSnapshot!.id).update({
                      "kovan_plaka": plaka,
                      "kovan_kapak_derece": kapak_derece
                    });
                    _kovanPlakaController.text = '';
                    _kovanSicaklikController.text = '';
                    _kovanNemController.text = '';
                    _kovanAgirlikController.text = '';
                    _kovanKapakDereceController.text = '';
                    _kovanKapakOnOffController.text = '';
                    _kovanPetekSayisiController.text = '';
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete(String hiveId) async {
    await _userHives?.doc(hiveId).delete();

    Fluttertoast.showToast(
        msg: "Kovan Başarıyla Silindi!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _updateElectricityState(bool isElectricityOn,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewHive()));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_florist,
                color: Colors.orangeAccent,
                size: 30.0,
              ),
              SizedBox(width: 8.0),
              Text(
                "Kovan Ekle",
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.0),
              Icon(
                Icons.local_florist,
                color: Colors.orangeAccent,
                size: 30.0,
              ),
            ],
          ),
        ),
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot<User?> authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!authSnapshot.hasData) {
                return Center(child: Text("Kullanıcı Girişi Gerekiyor"));
              }

              final userId = authSnapshot.data!.uid;
              _userHives = FirebaseFirestore.instance
                  .collection('Hives')
                  .doc('UserHives')
                  .collection(userId);

              return StreamBuilder(
                stream: _userHives!.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    // Veritabanından gelen öğelerin sayısına göre electricityStates listesini ayarla
                    if (_electricityStates.length !=
                        streamSnapshot.data!.docs.length) {
                      _electricityStates = List.generate(
                          streamSnapshot.data!.docs.length, (_) => false);
                    }
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              documentSnapshot['kovan_plaka'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sıcaklık: ${documentSnapshot['kovan_sicaklik'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Nem: ${documentSnapshot['kovan_nem'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Ağırlık: ${documentSnapshot['kovan_agirlik'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Kapak Durumu: ${documentSnapshot['kovan_kapak_on_off'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Kapak Açıklık: ${documentSnapshot['kovan_kapak_derece'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 180,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => _update(documentSnapshot),
                                    icon: const Icon(Icons.edit),
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _delete(documentSnapshot.id),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                  Switch(
                                    value: _electricityStates[index],
                                    // Her bir öğe için ayrı bir durum
                                    onChanged: (value) {
                                      setState(() {
                                        _electricityStates[index] =
                                            value; // Değeri değiştir
                                      });
                                      _updateElectricityState(
                                          _electricityStates[index],
                                          documentSnapshot); // Değişiklik yapıldığında _update metodu çalışsın
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }));
  }
}
