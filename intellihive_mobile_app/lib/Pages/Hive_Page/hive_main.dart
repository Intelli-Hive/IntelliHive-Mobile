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
          children: [
            TextField(
              controller: _kovanPlakaController,
              decoration: const InputDecoration(labelText: 'Kovan Plakası'),
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _kovanSicaklikController,
              decoration: const InputDecoration(labelText: 'Kovan Sıcaklık'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                child: const Text('Güncelle'),
                onPressed: () async {
                  final String plaka = _kovanPlakaController.text;
                  final String sicaklik = _kovanSicaklikController.text;
                  if (plaka != null) {
                    await _userHives
                        .doc(documentSnapshot!.id)
                        .update({"kovan_plaka": plaka, "kovan_sicaklik": sicaklik});
                    _kovanPlakaController.text = '';
                    _kovanSicaklikController.text = '';
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
                      title: Text(documentSnapshot['kovan_plaka']),
                      subtitle: Text(documentSnapshot['kovan_sicaklik']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => _update(documentSnapshot),
                                icon: const Icon(Icons.calendar_view_week)
                            ),
                            IconButton(
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete)
                            )
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
