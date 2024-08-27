import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intellihive_mobile_app/Pages/data_per_user.dart';
import 'Pages/Profile_Page/profile_main.dart';
import 'Pages/Hive_Page/hive_main.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyAqUhyRZPr0vK5SyTkueGfgRqB-gd8jYsA",
          appId: "1:954266985138:android:3af4e5cfe4ceeb8f589fab",
          messagingSenderId: "954266985138",
          projectId: "intellihivebee",
        ))
      : await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageViewDemo(),
    ),
  );
}

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  State<PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _pageController = PageController();
  int selectedPage = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [buildPageView(), buildBottomNav()]),
    );
  }

  Widget buildPageView() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        children: [
          //HomePage(),
          DataPerUserPage(),
          AddHivePage(),
          ProfilePage(),
        ],
        onPageChanged: onPageChange,
      ),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedPage,
      items: [
        BottomNavigationBarItem(label: "Petek Kontrol", icon: Icon(Icons.hive)),
        BottomNavigationBarItem(label: "Kovan Ekle", icon: Icon(Icons.add_box)),
        BottomNavigationBarItem(label: "Profilim", icon: Icon(Icons.person)),
        //BottomNavigationBarItem(label: "DataPerUser", icon: Icon(Icons.person)),
      ],
      onTap: (int index) {
        _pageController.animateToPage(index,
            duration: Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}

