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

String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

class _AddHivePageState extends State<AddHivePage> {
  double _sliderValue = 0.0;
  final CollectionReference _userHives =
  FirebaseFirestore.instance
      .collection('Hives')
      .doc('UserHives')
      .collection(userId);

  final _kovanPlakaController = TextEditingController();
  final _kovanSicaklikController = TextEditingController();
  final _kovanNemController = TextEditingController();
  final _kovanAgirlikController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null)  {
      _kovanPlakaController.text = documentSnapshot['kovan_plaka'];
      _kovanSicaklikController.text = documentSnapshot['kovan_sicaklik'];
      _kovanNemController.text = documentSnapshot['kovan_nem'];
      _kovanAgirlikController.text = documentSnapshot['kovan_agirlik'];
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
            TextField(
              controller: _kovanSicaklikController,
              decoration: const InputDecoration(labelText: 'Kovan Plakası'),
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _kovanNemController.text = value.toStringAsFixed(3);
                });
              },
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _kovanAgirlikController,
              decoration: const InputDecoration(labelText: 'Kovan Sıcaklık'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                child: const Text('Güncelle'),
                onPressed: () async {
                  final String plaka = _kovanPlakaController.text;
                  final String sicaklik = _kovanSicaklikController.text;
                  final String nem = _kovanNemController.text;
                  final String agirlik = _kovanAgirlikController.text;
                  if (plaka != null) {
                    await _userHives
                        .doc(documentSnapshot!.id)
                        .update({"kovan_plaka": plaka, "kovan_sicaklik": sicaklik, "kovan_nem": nem, "kovan_agirlik": agirlik});
                    _kovanPlakaController.text = '';
                    _kovanSicaklikController.text = '';
                    _kovanNemController.text = '';
                    _kovanAgirlikController.text = '';
                  }
                },
            )
          ],
        ),
      );
    }
    );
  }
  Future<void> _delete(String hiveId) async {
    await _userHives.doc(hiveId).delete();

    Fluttertoast.showToast(
        msg: "Kovan Başarıyla Silindi!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
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
            Text(
              "Kovan Ekle",
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _userHives.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData){
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['kovan_plaka'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sıcaklık: ${documentSnapshot['kovan_sicaklik']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Nem: ${documentSnapshot['kovan_nem']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Ağırlık: ${documentSnapshot['kovan_agirlik']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _update(documentSnapshot),
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                            ),
                            IconButton(
                              onPressed: () => _delete(documentSnapshot.id),
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
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
      ),
    );
  }
}
