import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewHive extends StatefulWidget {
  const NewHive({super.key});

  @override
  State<NewHive> createState() => _NewHiveState();
}


class _NewHiveState extends State<NewHive> {
  final _kovanPlakaController = TextEditingController();
  final _kovanSicaklikController = TextEditingController();
  final _kovanNemController = TextEditingController();
  final _kovanAgirlikController = TextEditingController();

  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kovan Bilgilerini Giriniz",
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // İlk metin giriş alanı
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kovan Plakasını Giriniz', // Başlık 1
                    style: TextStyle(
                      color: Colors.orange, // Turuncu rengi
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // Turuncu tonu burada
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5), // Yarı saydamlık ve turuncu tonu
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Gölgenin pozisyonu
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _kovanPlakaController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Plaka',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Bir boşluk ekleyebilirsiniz
        
              // İkinci metin giriş alanı
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kovan Petek Sayısını Giriniz', // Başlık 2
                    style: TextStyle(
                      color: Colors.orange, // Turuncu rengi
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // Turuncu tonu burada
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5), // Yarı saydamlık ve turuncu tonu
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Gölgenin pozisyonu
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _kovanSicaklikController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Petek Sayısı',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Bir boşluk ekleyebilirsiniz

              // Üçüncü metin giriş alanı
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bu Alan Otomatik Doldurulacaktır', // Başlık 3
                    style: TextStyle(
                      color: Colors.orange, // Turuncu rengi
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // Turuncu tonu burada
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5), // Yarı saydamlık ve turuncu tonu
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Gölgenin pozisyonu
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _kovanNemController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Bir boşluk ekleyebilirsiniz

              // Dördüncü metin giriş alanı
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bu Alan Otomatik Doldurulacaktır', // Başlık 3
                    style: TextStyle(
                      color: Colors.orange, // Turuncu rengi
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // Turuncu tonu burada
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5), // Yarı saydamlık ve turuncu tonu
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Gölgenin pozisyonu
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _kovanAgirlikController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Bir boşluk ekleyebilirsiniz

              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    HiveService().AddHive(userId: userId, kovan_plaka: _kovanPlakaController.text.trim(), kovan_sicaklik: _kovanSicaklikController.text.trim(), kovan_nem: "0", kovan_agirlik: "0");

                    Navigator.pop(context);

                    Fluttertoast.showToast(
                      msg: "Kovan Başarıyla Eklendi!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Butonun turuncu rengi
                  ),
                  child: Text(
                    'Ekle',
                    style: TextStyle(
                      color: Colors.white, // Beyaz yazı rengi
                    ),
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
