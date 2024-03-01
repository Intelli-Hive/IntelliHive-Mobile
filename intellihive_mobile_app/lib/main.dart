import 'dart:io';

import 'package:flutter/material.dart';

import 'Pages/Home_Page/home_main.dart';
import 'Pages/Profile_Page/profile_main.dart';
import 'Pages/Hive_Page/hive_main.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAqUhyRZPr0vK5SyTkueGfgRqB-gd8jYsA",
      appId: "1:954266985138:android:3af4e5cfe4ceeb8f589fab",
      messagingSenderId: "954266985138",
      projectId: "intellihivebee",
    )
  ) : await Firebase.initializeApp();
  runApp(
      const MaterialApp(
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
    // TODO: implement dispose
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
          HomePage(),
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
        BottomNavigationBarItem(label: "HomePage", icon: Icon(Icons.pages)),
        BottomNavigationBarItem(label: "HivePage", icon: Icon(Icons.pages)),
        BottomNavigationBarItem(label: "ProfilePage", icon: Icon(Icons.pages)),
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